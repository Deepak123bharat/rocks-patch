local record patch

    record Files
        source: {string}
        target: {string}
        epoch: {string}
        hunks: {string}
        fileends: {string}
        hunkends: {string}
    end
    read_patch: function(filename: string, data: string): {string}, boolean
end

return patch