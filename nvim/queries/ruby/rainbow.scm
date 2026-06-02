; Ruby function defs
(method 
  "def" @rainbow.start
  (_)*
  "end" @rainbow.end)

; Ruby classes
(class 
  "class" @rainbow.start
  (_)*
  "end" @rainbow.end)

; Ruby modules
(module 
  "module" @rainbow.start
  (_)*
  "end" @rainbow.end)

; Blocks like do ... end
(do_block 
  "do" @rainbow.start
  (_)*
  "end" @rainbow.end)

