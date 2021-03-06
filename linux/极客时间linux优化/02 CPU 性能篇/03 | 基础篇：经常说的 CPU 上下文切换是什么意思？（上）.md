03 | 基础篇：经常说的 CPU 上下文切换是什么意思？（上）
-----

上下文切换种类:

- 进程上下文切换
- 线程上下文切换
- 中断上下文切换

#### # 进程上下文切换

- 内核空间 具有最高权限,可以直接访问所有资源
- 用户空间 只能访问受限资源,不能直接访问内存等硬件设备,必须通过系统调用,陷入到内核当中,才能访问这些特权资源


CPU 寄存器里原来用户态的指令位置，需要先保存起来。接着，为了执行内核态代码，CPU 寄存器需要更新为内核态指令的新位内核态指令的新位置。 最后才是跳转到内核态运行内核任务.
而系统调用结束后，CPU 寄存器需要恢复原来保存的用户态，然后再切换到用户空间，继续运行进程。

> 一次系统调用过程,其实发生了2次CPU 上下文切换

系统调用过程,并不会设计到虚拟内存等进程用户态的资源,也不会切换进程,这跟我们通常所说的进程上下文切换是不一样的.

- 进程上下文切换,是指从一个进程切换到另外一个进程运行
- 而系统调用过程中一直是一个进程在运行

**上下文切换的情况**

- 为了确保所有进程都可以得到公平调度,将时间划分为片段,分配给各个进程,当某个进程的时间片耗尽了,就会被挂起,切换其他进程运行
- 进程在系统资源不足(比如内存不足)时,要等资源满足时候才能运行,这时候进程被挂起,并且调度其他进程运行
- 当进程调用睡眠函数 sleep, 将自己主动挂起
- 当有优先级更高的进程运行时,为了确保高优先级进程的运行,当前进程被挂起,由高优先级进程来运行
- 发生硬件终端,CPU 上的进程被中断挂起,转而执行内核中的终端服务进程


#### # 线程上下文切换

线程与进程最大的区别在于，线程是调度的基本单位，而进程则是资源拥有的基本单位。说白了，所谓内核中的任务调度，实际上的调度对象是线程；而进程只是给线程提供了虚拟内存、全局变量等资源。所以，对于线程和进程，我们可以这么理解：

当进程只有一个线程时，可以认为进程就等于线程。

当进程拥有多个线程时，这些线程会共享相同的虚拟内存和全局变量等资源。这些资源在上下文切换时是不需要修改的。

另外，线程也有自己的私有数据，比如栈和寄存器等，这些在上下文切换时也是需要保存的。

这么一来，线程的上下文切换其实就可以分为两种情况：

- 第一种， 前后两个线程属于不同进程。此时，因为资源不共享，所以切换过程就跟进程上下文切换是一样。
- 第二种，前后两个线程属于同一个进程。此时，因为虚拟内存是共享的，所以在切换时，虚拟内存这些资源就保持不动，只需要切换线程的私有数据、寄存器等不共享的数据。

到这里你应该也发现了，虽然同为上下文切换，但同进程内的线程切换，要比多进程间的切换消耗更少的资源，而这，也正是多线程代替多进程的一个优势。

#### # 中断上下文切换

除了前面两种上下文切换，还有一个场景也会切换 CPU 上下文，那就是中断。

为了快速响应硬件的事件，中断处理会打断进程的正常调度和执行，转而调用中断处理程序，响应设备事件。而在打断其他进程时，就需要将进程当前的状态保存下来，这样在中断结束后，进程仍然可以从原来的状态恢复运行。

跟进程上下文不同，中断上下文切换并不涉及到进程的用户态。所以，即便中断过程打断了一个正处在用户态的进程，也不需要保存和恢复这个进程的虚拟内存、全局变量等用户态资源。中断上下文，其实只包括内核态中断服务程序执行所必需的状态，包括 CPU 寄存器、内核堆栈、硬件中断参数等。

对同一个 CPU 来说，中断处理比进程拥有更高的优先级，所以中断上下文切换并不会与进程上下文切换同时发生。同样道理，由于中断会打断正常进程的调度和执行，所以大部分中断处理程序都短小精悍，以便尽可能快的执行结束。

另外，跟进程上下文切换一样，中断上下文切换也需要消耗 CPU，切换次数过多也会耗费大量的 CPU，甚至严重降低系统的整体性能。所以，当你发现中断次数过多时，就需要注意去排查它是否会给你的系统带来严重的性能问题。


小结
----

总结一下，不管是哪种场景导致的上下文切换，你都应该知道：

1. CPU 上下文切换，是保证 Linux 系统正常工作的核心功能之一，一般情况下不需要我们特别关注。

2. 但过多的上下文切换，会把 CPU 时间消耗在寄存器、内核栈以及虚拟内存等数据的保存和恢复上，从而缩短进程真正运行的时间，导致系统的整体性能大幅下降。