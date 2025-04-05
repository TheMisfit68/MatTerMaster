#
#  UserAliases.sh
#  MatTerMaster
#
#  Created by Jan Verrept on 29/10/2024.
#

# Add some personal aliases for your convenience during development

# Quick testing of various framework examples,
# to make sure everything is in working order at different levels of the toolchain.
alias testidf='navigateTo $HOME/esp/esp-idf/examples/get-started/blink && clean && build'
alias testmatter='navigateTo $HOME/esp/esp-matter/examples/light && clean && build'
alias testapple='navigateTo $HOME/Apple-swift-matter/swift-matter-examples/led-blink && clean && build'
alias testsmart='navigateTo $HOME/Apple-swift-matter/swift-matter-examples/smart-light && clean && build'
alias testjv='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterTest && clean && build'

# Quick navigation to those same framework examples
alias goidf='navigateTo $HOME/esp/esp-idf/examples/get-started/blink'
alias gomatter='navigateTo $HOME/esp/esp-matter/examples/light'
alias goapple='navigateTo $HOME/Apple-swift-matter/swift-matter-examples/led-blink'
alias gosmart='navigateTo $HOME/Apple-swift-matter/swift-matter-examples/smart-light'
alias gojv='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterTest'

# Quick navigation to my own Matter targets
alias goblinker='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterBlinker'
alias goglower='navigateTo $HOME/JVEmbedded/JVMatter/Sources/MatterGlower'
alias goswitch='navigateTo $HOME/esp/esp-matter/examples/generic_switch'





