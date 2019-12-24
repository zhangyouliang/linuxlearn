#### mongodb
> http://www.runoob.com/mongodb/mongodb-query.html

#### # 查询

    db.collection.find(query,projection).pretty()

    等于	{<key>:<value>}	db.col.find({"by":"菜鸟教程"}).pretty()	where by = '菜鸟教程'
    小于	{<key>:{$lt:<value>}}	db.col.find({"likes":{$lt:50}}).pretty()	where likes < 50
    小于或等于	{<key>:{$lte:<value>}}	db.col.find({"likes":{$lte:50}}).pretty()	where likes <= 50
    大于	{<key>:{$gt:<value>}}	db.col.find({"likes":{$gt:50}}).pretty()	where likes > 50
    大于或等于	{<key>:{$gte:<value>}}	db.col.find({"likes":{$gte:50}}).pretty()	where likes >= 50
    不等于	{<key>:{$ne:<value>}}	db.col.find({"likes":{$ne:50}}).pretty()	where likes != 50


#### # And 语句

    db.col.find({key1:value1, key2:value2}).pretty()

#### # Or 条件

    db.col.find(
    {
        $or: [
            {key1: value1},{key2: value2}
        ]
    }
    ).pretty()

#### # And Or 联合使用
    
    db.col.find({"likes": {$gt:50}, $or: [{"by": "菜鸟教程"},{"title": "MongoDB 教程"}]}).pretty()

    # _id 键默认返回，需要主动指定 _id:0 才会隐藏
    db.collection.find(query, {_id:0, title: 1, by: 1})
    
    # 若不想指定查询条件参数 query 可以 用 {} 代替，但是需要指定 projection 参数：
    querydb.collection.find({}, {title: 1})
    

#### # MongoDB 删除文档

- query :（可选）删除的文档的条件。
- justOne : （可选）如果设为 true 或 1，则只删除一个文档。
- writeConcern :（可选）抛出异常的级别。


    db.collection.remove(<query>,<justOne>)
    
    # 删除全部数据
    db.col.remove({})


#### # 文档插入

    db.col.insert({title: 'MongoDB 教程'})

#### # 文档更新

    db.collection.update(
       <query>,
       <update>,
       {
         upsert: <boolean>,
         multi: <boolean>,
         writeConcern: <document>
       }
    )

参数说明：

- query : update的查询条件，类似sql update查询内where后面的。
- update : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
- upsert : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。
- multi : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。
- writeConcern :可选，抛出异常的级别。

#### # 删除集合
    
    db.collection.drop()
    

#### # limit 和 skip 方法

- limit 显示条数
- skip 跳过的条数

> db.COLLECTION_NAME.find().limit(NUMBER).skip(NUMBER)

    db.col.find({},{"title":1,_id:0}).limit(1).skip(1)


#### # 排序
> db.COLLECTION_NAME.find().sort({KEY:1})

- 1 : 升序
- -1 : 降序

#### # 索引
> db.col.createIndex({"title":1,"description":-1})
> db.col.dropIndex({"title":1,"description":-1})

- 1 : 升序
- -1 : 降序 
  - 
> 1、查看集合索引 db.col.getIndexes()
> 2、查看集合索引大小 db.col.totalIndexSize()
> 3、删除集合所有索引 db.col.dropIndexes()
> 4、删除集合指定索引 db.col.dropIndex("索引名称")


#### # 聚合
> db.COLLECTION_NAME.aggregate(AGGREGATE_OPERATION)

    数据结构
    {
       _id: ObjectId(7df78ad8902c)
       title: 'MongoDB Overview', 
       description: 'MongoDB is no sql database',
       by_user: 'runoob.com',
       url: 'http://www.runoob.com',
       tags: ['mongodb', 'database', 'NoSQL'],
       likes: 100
    },
    查询语句 
    db.mycol.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : 1}}}])
    {
       "result" : [
          {
             "_id" : "runoob.com",
             "num_tutorial" : 2
          },
          {
             "_id" : "Neo4j",
             "num_tutorial" : 1
          }
       ],
       "ok" : 1
    }
    ===> 
    select by_user, count(*) from mycol group by by_user

其他聚合表达式:

- $sum 计算总和
- $avg 计算平均值
- $min 获取集合中所有文档对应值得最小值。
- $max 获取集合中所有文档对应值得最大值。
- $push 在结果文档中插入值到一个数组中。
- $addToSet	在结果文档中插入值到一个数组中，但不创建副本。
- $first	根据资源文档的排序获取第一个文档数据。
- $last	根据资源文档的排序获取最后一个文档数据

#### # 管道概念

- $project：修改输入文档的结构。可以用来重命名、增加或删除域，也可以用于创建计算结果以及嵌套文档。
- $match：用于过滤数据，只输出符合条件的文档。$match使用MongoDB的标准查询操作。
- $limit：用来限制MongoDB聚合管道返回的文档数。
- $skip：在聚合管道中跳过指定数量的文档，并返回余下的文档。
- $unwind：将文档中的某一个数组类型字段拆分成多条，每条包含数组中的一个值。
- $group：将集合中的文档分组，可用于统计结果。
- $sort：将输入文档排序后输出。
- $geoNear：输出接近某一地理位置的有序文档。




