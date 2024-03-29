
- 根据原来的表结构执行 alter 语句，新建一个更新表结构之后的表，通常称为幽灵表。对用户不可见。
- 把原来表的已有数据 copy 到幽灵表。
- 在 copy 的过程中，会有新的数据过来，这些数据要同步到幽灵表，也就是 “Online” 的精髓。
- copy 和同步完成后，锁住源表，交换表名，幽灵表替换源表。
- 删除源表（可选），完成 online DDL。


这其中比较重要的第三步，如何同步增量的数据。最开始办法就是使用触发器，在源表上增加几个触发器，例如当源表执行 INSERT，UPDATE，DELETE 语句，就把这些操作通过触发器同步到幽灵表上，这样在幽灵表上执行的语句和源表的语句就属于同一个事务，显然这样会影响主库的性能。

后面出现了异步的模式，使用触发器把对源表的操作保存到一个 Changelog 表中，不真正的去执行，专门有一个后台的线程从 Changelog 表读取数据应用到幽灵表上。这种方式一定程度上缓解了主库的压力，但是保存到 Changelog 表也同样是属于同一个事务中，对性能也有不小的影响。