#### ansible 使用不同端口
 
    [local:vars]
    ansible_ssh_user="root"
    ansible_ssh_port=2223
    [local]
    127.0.0.1

> 使用 ansible-playbook 的 --syntax-check 标识。通过parser来运行playbook，确保Include files、roles等没有语法错误。

> ansible-playbook playbook.yml --list-hosts

> 特权上升的方式更改为 become

> a运行playbook的方式: nsible-playbook playbook.yml -f 10
