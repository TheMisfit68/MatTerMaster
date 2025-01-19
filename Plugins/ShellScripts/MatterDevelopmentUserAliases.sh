#
#  UserAliases.sh
#  MatTerMaster
#
#  Created by Jan Verrept on 29/10/2024.
#

# Add some personal aliases for your convenience during development

# Quick navigation to various examples
alias goidf='navigateTo $HOME/esp/esp-idf/examples/get-started/blink'
alias gomatter='navigateTo $HOME/esp/esp-matter/examples/light'
alias goapple='navigateTo $HOME/Apple-swift-matter/swift-matter-examples/led-blink'
alias gosmart='navigateTo $HOME/Apple-swift-matter/swift-matter-examples/smart-light'
alias gojv='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterTest'
alias gomswitch='navigateTo $HOME/esp/esp-matter/examples/generic_switch'
alias gomall='navigateTo $HOME/esp/esp-matter/examples/all_device_types_app'


# Quick testing of various examples, to make sure the complete toolchain is in working order
alias testidf='navigateTo $HOME/esp/esp-idf/examples/get-started/blink && clean && build'
alias testmatter='navigateTo $HOME/esp/esp-matter/examples/light && clean && build'
alias testapple='navigateTo $HOME/Apple-swift-matter/swift-matter-examples/led-blink && clean && build'
alias testsmart='navigateTo $HOME/Apple-swift-matter/swift-matter-examples/smart-light && clean && build'


# Navigate within my own Matter projects
alias projectFolder='navigateTo $HOME/JVEmbedded/JVMatter/Sources/'
alias blinker='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterBlinker'
alias glower='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterGlower'
alias switch='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterGenericSwitch'

alias testjv='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterTest && clean && build'
alias testswitch='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterGenericSwitch && clean && build'




