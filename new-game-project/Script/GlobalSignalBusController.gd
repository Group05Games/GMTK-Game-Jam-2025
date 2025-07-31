extends Node

## Example of Singal Structure
## Before any functions create the signal as below:
## signal Name_Of_Signal(Variables_To_Pass_X, Variables_To_Pass_Y)

##Inside the _ready() script that is going to "Talk" create the listener:
## Object.Name_Of_Signal.connect(Function_To_Call)

## When calling the signal:
## emit_signal(Name_Of_Signal, Variables_To_Pass_X, Variables_To_Pass_Y)
