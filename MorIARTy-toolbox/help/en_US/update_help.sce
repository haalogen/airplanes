function update_help()
    this_dir = get_absolute_file_path("update_help.sce");
    exec(fullpath("help/macros_to_document.sce"));
    for i = 1 : size(macros_to_document, 1)
        funcname = macros_to_document(i, 1);
        dest_dir = fullpath(this_dir + "/" + macros_to_document(i, 2));
        help_from_sci("macros" + filesep() + funcname, dest_dir);
    end
endfunction

update_help();
clear update_help;
