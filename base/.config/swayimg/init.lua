-- swayimg — managed via ~/.dotfiles (stow: base)

swayimg.enable_exif_orientation(true) -- auto-rotate by EXIF orientation

-- Preload/cache so navigation is instant in both directions
swayimg.viewer.limit_preload(3)
swayimg.viewer.limit_history(3)

-- Shooting metadata overlay (toggle with 't')
swayimg.viewer.set_text("topleft", {
    "{name}",
    "{meta.Exif.Image.Make} {meta.Exif.Image.Model}",
    "{meta.Exif.Photo.LensModel}",
    "{meta.Exif.Photo.FocalLength}  {meta.Exif.Photo.FNumber}  {meta.Exif.Photo.ExposureTime}  ISO {meta.Exif.Photo.ISOSpeedRatings}",
    "{meta.Exif.Photo.DateTimeOriginal}",
})
swayimg.viewer.set_text("topright", {
    "{list.index} of {list.total}",
})

-- vim-style navigation
swayimg.viewer.on_key("h", function()
    swayimg.viewer.switch_image("prev")
end)
swayimg.viewer.on_key("l", function()
    swayimg.viewer.switch_image("next")
end)

-- set current image as wallpaper
swayimg.viewer.on_key("Shift-w", function()
    local image = swayimg.viewer.get_image()
    os.execute(os.getenv("HOME") .. '/.local/scripts/set-wallpaper.sh "' .. image.path .. '" &')
end)
