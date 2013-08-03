class Log

    def Log.debug(message, show_debug = true)
        string = message.to_s
        string = Log.green("DEBUG") + ": " + string if show_debug
        Log.write(string)
    end

    def Log.entering_method(method, params)
        log  = "#{Log.green("Method")}: #{method}, #{Log.yellow('Params')}: #{params.inspect}"
        Log.write(log, "methods.log")
    end
    
    def Log.title(message)
        Log.write("#{Log.yellow("########## #{message.to_s} ##########")}")
    end

    def Log.minititle(message)
        Log.write("#{Log.blue("---------- #{message.to_s} ----------")}")
    end

    def Log.error(message)
        Log.write("#{Log.red("ERROR")}: " + message.to_s)
    end

    def Log.warning(message)
        Log.write("#{Log.yellow("WARNING")}: " + message.to_s)
    end

    def Log.exception(ex)
        exception_file = "exceptions.log"
        Log.write("#{Log.red("EXCEPTION")}: " + ex.message)
        Log.write(Log.yellow("=================================================================================="), exception_file)
        Log.write(ex.message, exception_file)
        ex.backtrace.each { |line| Log.write(line, exception_file) }
    end

    def Log.command(cmd, output, exit_status)
        output  = "none" if output == nil || output.strip == ""
        cmdtext = if exit_status == 0 then Log.blue("COMMAND") else Log.red("COMMAND") end
        Log.write("#{cmdtext}: #{cmd}" )
        Log.write("#{Log.red("OUTPUT")}: #{output.strip}") unless exit_status == 0
        Log.write("#{Log.red("EXIT")}: #{exit_status}") unless exit_status == 0
    end
    
    def Log.surround(text, back, fore)
        first    = ".[#{back};#{fore}m"
        first[0] = 27
        last     = ".[00m"
        last[0]  = 27
        "#{first}#{text}#{last}"
    end

    def Log.cyan(text)
        #surround(text, "01", "36")
        text.cyan
    end

    def Log.purple(text)
        #surround(text, "01", "35")
        text.magenta
    end
    
    def Log.blue(text)
        #surround(text, "01", "34")
        text.blue
    end

    def Log.red(text)
        #surround(text, "01", "31")
        text.red
    end

    def Log.yellow(text)
        #surround(text, "01", "33")
        text.yellow
    end

    def Log.green(text)
        #surround(text, "01", "32")
        text.green
    end

    def Log.write(message, filename = "debug.log")
        message = "#{Log.cyan(Time.now.to_i.to_s)}: " + message
        logfile = "#{Rails.root}/log/#{filename}"
        file = File.open(logfile, "a")
        file.write(message + "\n")
        file.close
    end
end
