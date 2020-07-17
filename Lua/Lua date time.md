Lua 里面处理时间基本 Date 和 Time 就能满足

## Time

设定，创建时间

```
year	a full year
month	01-12
day	01-31
hour	00-23
min	00-59
sec	00-59
isdst	a boolean, true if daylight saving
```

```lua
-- obs: 10800 = 3*60*60 (3 hours)
print(os.time{year=1970, month=1, day=1, hour=0})
--> 10800
print(os.time{year=1970, month=1, day=1, hour=0, sec=1})
--> 10801
print(os.time{year=1970, month=1, day=1})
--> 54000   (obs: 54000 = 10800 + 12*60*60)
```

## Date

对时间进行格式化

```
%a	abbreviated weekday name (e.g., Wed)
%A	full weekday name (e.g., Wednesday)
%b	abbreviated month name (e.g., Sep)
%B	full month name (e.g., September)
%c	date and time (e.g., 09/16/98 23:48:10)
%d	day of the month (16) [01-31]
%H	hour, using a 24-hour clock (23) [00-23]
%I	hour, using a 12-hour clock (11) [01-12]
%M	minute (48) [00-59]
%m	month (09) [01-12]
%p	either "am" or "pm" (pm)
%S	second (10) [00-61]
%w	weekday (3) [0-6 = Sunday-Saturday]
%x	date (e.g., 09/16/98)
%X	time (e.g., 23:48:10)
%Y	full year (1998)
%y	two-digit year (98) [00-99]
%%	the character `%´
```

```lua
print(os.date("today is %A, in %B"))
--> today is Tuesday, in May
print(os.date("%x", 906000490))
--> 09/16/1998
```

## 其他

```lua
# 间隔时间
local testDate = os.time{year=1970, month=1, day=1, hour=0}
local offDate = math.ceil(os.difftime(os.time() - testDate)/ (24 * 60 * 60))
print(offDate)
```

## 参考
* [Lua.org](https://www.lua.org/pil/22.1.html)