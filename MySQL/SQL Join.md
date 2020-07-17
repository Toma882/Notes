#SQL Join

假设我们有两张表，Table A是左边的表，Table B是右边的表。

其各有四条记录，其中有两条记录是相同的，如下所示：

```sql
id name       id  name
-- ----       --  ----
1  Pirate     1   Rutabaga
2  Monkey     2   Pirate
3  Ninja      3   Darth Vader
4  Spaghetti  4   Ninja
```
下面让我们来看看不同的Join会产生什么样的结果。

## Inner join
产生的结果集中，是A和B的交集。

![](./assets/sql%20join%20INNER.png)

```sql
SELECT * FROM TableA INNER JOIN TableB
ON TableA.name = TableB.name
id  name       id   name
--  ----       --   ----
1   Pirate     2    Pirate
3   Ninja      4    Ninja
```

## Full outer join
产生A和B的并集。但是需要注意的是，对于没有匹配的记录，则会以null做为值。

![](./assets/sql%20join%20FULL%20OUTER.png)

```sql
SELECT * FROM TableA FULL OUTER JOIN TableB
ON TableA.name = TableB.name
id    name       id    name
--    ----       --    ----
1     Pirate     2     Pirate
2     Monkey     null  null
3     Ninja      4     Ninja
4     Spaghetti  null  null
null	null	1     Rutabaga
null	null	3     Darth Vader
```

## Left outer join
产生表A的完全集，而B表中匹配的则有值，没有匹配的则以null值取代。

![](./assets/sql%20join%20LEFT%20OUTER.png)

```sql
SELECT * FROM TableA LEFT OUTER JOIN TableB ON TableA.name = TableB.name
id  name       id    name
--  ----       --    ----
1   Pirate     2     Pirate
2   Monkey		null	null
3   Ninja      4     Ninja
4   Spaghetti	null	null
```

## 产生在A表中有而在B表中没有的集合
![](./assets/sql%20join%20LEFT%20OUTER%20Not%20NULL.png)

```sql
SELECT * FROM TableA LEFT OUTER JOIN TableB ON TableA.name = TableB.name WHERE TableB.id IS null
id  name       id     name
--  ----       --     ----
2   Monkey	null	null
4   Spaghetti	null	null
```

## 产生A表和B表都没有出现的数据集

![](./assets/sql%20join%20FULL%20OUTER%20ALL%20NULL.png)

```sql
SELECT * FROM TableA FULL OUTER JOIN TableB ON TableA.name = TableB.name WHERE TableA.id IS null OR TableB.id IS null
id    name       id    name
--    ----       --    ----
2     Monkey	null	null
4     Spaghetti	null	null
null	null	1     Rutabaga
null	null	3     Darth Vader
```

## "交差集" cross join
其就是把表A和表B的数据进行一个N*M的组合，即笛卡尔积

这个笛卡尔乘积会产生 4 x 4 = 16 条记录，一般来说，我们很少用到这个语法。但是我们得小心，如果不是使用嵌套的select语句，一般系统都会产生笛卡尔乘积然再做过滤。这是对于性能来说是非常危险的，尤其是表很大的时候。

```sql
SELECT * FROM TableA
CROSS JOIN TableB
```