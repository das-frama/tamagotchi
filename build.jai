OUTPUT_EXECUTABLE_NAME :: "tamagotchi";

DEBUG :: true;
EDITOR :: true;

#run {
    set_build_options_dc(.{do_output = false});

    args := get_build_options().compile_time_command_line;

    os_target := OS;
    cpu_target := CPU;

    log("Compiling for % %", os_target, cpu_target);

    build_output_directory := "";

    w := compiler_create_workspace("Target workspace");

    options := get_build_options(w);
    copy_commonly_propagated_fields(get_build_options(), *options);
    options.cpu_target = cpu_target;
    options.os_target  = os_target;
    options.output_executable_name = OUTPUT_EXECUTABLE_NAME;

    optimization: Optimization_Type = .DEBUG;
    if !DEBUG optimization = .VERY_OPTIMIZED;
    set_optimization(*options, optimization);

    if cpu_target == .ARM64 {
        options.backend = .LLVM;
        options.llvm_options.target_system_features = "+lse";
    }

    options.output_path = build_output_directory;

    set_build_options(options, w);
    compiler_begin_intercept(w);
    add_build_string(tprint("DEBUG :: %;", DEBUG), w);
    add_build_string(tprint("EDITOR :: %;", EDITOR), w);
    add_build_file("source/main.jai", w);
    compiler_end_intercept(w);
}

#import "Basic";
#import "Compiler";
#import "File";
#import "File_Utilities";
#import "String";