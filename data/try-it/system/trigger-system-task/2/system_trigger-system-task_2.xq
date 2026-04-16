let $java-classname := "hello"
let $task-parameters := <item>value</item>
return
    system:trigger-system-task($java-classname, $task-parameters)