# Mac Configuration Setup

## Disable boot on open
`sudo nvram AutoBoot=%00`

### Re-enable
`sudo nvram AutoBoot=%03`

### Check setting
`nvram -p`

## Keyboard repeating
`defaults write -g ApplePressAndHoldEnabled -bool true`
