
```lua
function start()
    local startTime = os.clock()
    for i=1,200000 do
        self.transform:Rotate (15, 30, 45)
    end
    local endTime = os.clock()
    print(endTime - startTime)
end
```

