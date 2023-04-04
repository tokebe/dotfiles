cwd=$(pwd) # store current directory

# clone minimal required to build Iosevka
git clone --depth 1 https://github.com/be5invis/Iosevka.git ~/.cache/iosevka

# copy build plans
cp ./private-build-plans.toml

# build iosevka fonts
cd ~/.cache/iosevka
npm install --package-lock-only
npm run build -- ttf::iosevka-perfected-001

# clone nerd fonts patcher
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts ~/.cache/nerd-fonts

# patch
cd ~/.cache/nerd-fonts
# TODO detect each font in dist/iosevka-perfected-001 and patch each one

# TODO copy to either /usr/share/fonts or ~/Library/Fonts for linux or mac, respectively
# TODO skip steps if they already exist
# TODO use a new .version file to manage the name of the font
#      in case of new font versions or whatever
