/*
 * g++ -o test_epoll ./test_epoll.c
 */
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/epoll.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int SetReuseAddr(int fd)
{
    int optval = 1;
    socklen_t optlen = sizeof(optval);
    return setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &optval, optlen);
}

int main()
{
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    int iRet = SetReuseAddr(fd);
    if (iRet != 0)
    {
        printf("setsockopt for SO_REUSEADDR failed, error:%s\n", strerror(iRet));
        return iRet;
    }

    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(8080);
    addr.sin_addr.s_addr = INADDR_ANY;
    if (bind(fd, (struct sockaddr*)&addr, sizeof(addr))  == -1)
    {
        printf("bind failed, error:%s\n", strerror(errno));
        return errno;
    }

    if (listen(fd, 5) == -1)
    {
        printf("listen failed, error:%s\n", strerror(errno));
        return errno;
    }
    printf("Listening on 8080...\n");

    int epfd = epoll_create(102400);
    struct epoll_event event;
    event.events = EPOLLIN;
    event.data.fd = fd;
    epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &event);

    struct epoll_event revents[102400];
    int iOnline = 0;
    while (1)
    {
        int num = epoll_wait(epfd, revents, 102400, 60 * 1000);
        printf("epoll_wait return %d\n", num);
        if (num > 0)
        {
            for (int i = 0; i < num; i++)
            {
                if (revents[i].data.fd == fd)
                {
                    int client;
                    struct sockaddr_in cli_addr;
                    socklen_t cli_addr_len = sizeof(cli_addr);
                    client = accept(fd, (struct sockaddr*)&cli_addr, &cli_addr_len);
                    if (client == -1)
                    {
                        printf("accept failed, error:%s\n", strerror(errno));
                        if (errno == EMFILE)
                        {
                            printf("per-process limit reached\n");
                            exit(errno);
                        }
                        if (errno == ENFILE)
                        {
                            printf("system-wide limit reached\n");
                            exit(errno);
                        }
                        continue;
                    }

                    iOnline++;
                    printf("Receive a new connection from %s:%d\n", inet_ntoa(cli_addr.sin_addr), cli_addr.sin_port);
                    event.events = EPOLLIN;
                    event.data.fd = client;
                    epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &event);
                }
            }
        }
        printf("Online number:%d\n", iOnline);
    }

    return 0;
}
