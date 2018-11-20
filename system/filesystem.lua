local Filesystem = {}

function Filesystem.inGameLS(dir)
    local output = {}
    local path = 'files/' .. dir
    local files = love.filesystem.getDirectoryItems(path)
    for i,filename in ipairs(files) do
        local info = love.filesystem.getInfo(path..'/'..filename)
        if info.type == 'file' then
            append(output,createFileObject(filename))
        end

        if info.type == 'directory' then
            append(output,createFolderObject(filename,dir))
        end
    end
    return output
end

function Filesystem.ls(dir)
    local output = {}
    local path = dir
    local files = love.filesystem.getDirectoryItems(path)
    for i,filename in ipairs(files) do
        local info = love.filesystem.getInfo(path..'/'..filename)
        if info.type == 'file' then
            append(output,createFileObject(filename))
        end

        if info.type == 'directory' then
            append(output,createFolderObject(filename,dir))
        end
    end
    return output
end

function createFileObject(filename)
    local ext = filename:split('.')[2]
    local ic = 'app'
    if ext == 'txt' then
        ic = 'text'
    end

    if ext == 'png' then
        ic = 'image'
    end

    return {icon=ic,name=filename}
end

function createFolderObject(filename,path)
    return {icon='folder',name=filename, dir=path..filename..'/'}
end

return Filesystem