D-lang api wrapper for llm-inference chatllm.cpp

All credits go to original repo: https://github.com/foldl/chatllm.cpp, gpt 4 telegram bot, qwen coder 32b instruct and rikki_cattermole from official D-lang discord for his advice: "D doesn't use pointers for strings. It uses slices, which is a length + pointer pair".

You can make exe running this command line: ldc2 libchatllm.lib main.d

Original libchatllm.dll, ggml.dll and libchatllm.lib can be found in original repo already mentioned above. 
