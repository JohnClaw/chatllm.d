import std.stdio;
import std.string : fromStringz, toStringz;
import core.stdc.stdlib;

extern(C) {
    void* chatllm_create();
    void chatllm_abort_generation(void* obj);
    int chatllm_start(void* obj, void function(void*, int, const(char)*) printCallback, void function(void*) endCallback, void* userData);
    int chatllm_user_input(void* obj, const(char)* input);
    void chatllm_append_param(void* obj, const(char)* param);
}

// Declare the callback functions with extern(C) linkage
extern(C) void chatllmPrint(void* userData, int printType, const(char)* utf8Str) {
    auto dStr = fromStringz(utf8Str);
    if (printType == 0) {
        write(dStr);
    } else {
        writeln(dStr);
    }
}

extern(C) void chatllmEnd(void* userData) {
    writeln();
}

void main(string[] args) {
    void* obj = chatllm_create();
    if (obj == null) {
        stderr.writefln("chatllm_create failed");
        return;
    }
    scope(exit) chatllm_abort_generation(obj);

    // Append command-line arguments to the chat object
    for (int c = 1; c < args.length; c++) {
        chatllm_append_param(obj, toStringz(args[c]));
    }

    int startResult = chatllm_start(obj, &chatllmPrint, &chatllmEnd, null);
    if (startResult != 0) {
        stderr.writefln(">>> chatllm_start error: %d", startResult);
        return;
    }

    int userInputResult;
    while (true) {
        write("You > ");
        char[] input = readln().dup;
        if (input.length <= 1) continue; // Skip empty input

        writeln("User input: ", input);
        write("A.I. > ");
        userInputResult = chatllm_user_input(obj, toStringz(input));
        if (userInputResult != 0) {
            stderr.writefln(">>> chatllm_user_input error: %d", userInputResult);
            break;
        }
    }
}