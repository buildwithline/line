# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true

pin '@rails/actioncable', to: 'actioncable.esm.js'
pin '@rails/activestorage', to: 'activestorage.esm.js'
pin '@rails/actiontext', to: 'actiontext.esm.js'
pin 'trix'
