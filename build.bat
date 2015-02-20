@echo on

echo remove prior js files
echo y|del output\*.* 
call coffee --output output --compile lib tests

echo done building

cd c:\wamp\www
xcopy c:\source\rogue-arena  /e /y
cd c:\source\rogue-arena
echo done