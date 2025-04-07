# frozen_string_literal: true

LABEL_CLASSES = 'block text-sm font-medium text-gray-700 mb-1'
INPUT_CLASSES = %w[
  block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-indigo-600 sm:text-sm/6
].join(' ').freeze

BUTTON_CLASSES = %w[
  inline-flex items-center px-4 py-2 border border-transparent
  text-sm font-medium text-white
  rounded-md shadow-sm bg-primary-dark hover:bg-primary-darker
  focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-dark
  cursor-pointer
].join(' ').freeze

SimpleForm.setup do |config| # rubocop:disable Metrics/BlockLength
  config.wrappers :default, class: 'h-20 h-auto min-h-fit' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: LABEL_CLASSES, error_class: 'text-red-900'
    b.use :input, class: INPUT_CLASSES,
                  error_class: 'border-red-300 text-red-900 placeholder-red-300 focus:ring-red-500 focus:border-red-500'
    b.use :error, wrap_with: { tag: :p, class: 'ml-2 text-sm text-red-600' }
  end

  config.wrappers :boolean, class: 'flex items-center' do |b|
    b.use :html5
    b.use :input, class: 'h-4 w-4 text-primary-dark focus:ring-primary-dark border-gray-300 rounded'

    b.use :label, class: 'ml-2 block text-sm text-gray-900',
                  error_class: 'underline decoration-red-500 decoration-2 underline-offset-4 decoration-dashed'
    b.use :error, wrap_with: { tag: :p, class: 'ml-2 text-sm text-red-600' }
  end

  config.wrappers :radio_buttons, item_wrapper_class: 'flex items-center',
                                  item_label_class: 'ml-3 block text-sm font-medium text-gray-700',
                                  tag: 'fieldset',
                                  class: '' do |b|
    b.use :html5
    b.wrapper :legend_tag, tag: 'legend', class: LABEL_CLASSES do |ba|
      ba.use :label_text
    end
    b.wrapper :radios, class: 'space-y-4' do |ba|
      ba.use :input, class: 'h-4 w-4 border-gray-300 text-primary-dark focus:ring-primary-dark', error_class: ''
    end
  end

  config.wrappers :inline_radio_buttons, item_wrapper_class: 'flex items-center',
                                         item_label_class: 'ml-3 block text-sm font-medium text-gray-700',
                                         class: 'flex items-center space-x-4' do |b|
    b.use :html5
    b.wrapper :legend_tag, class: "#{LABEL_CLASSES} mb-0" do |ba|
      ba.use :label_text
    end
    b.wrapper :radios, class: 'flex space-x-4' do |ba|
      ba.use :input, class: 'h-4 w-4 border-gray-300 text-primary-dark focus:ring-primary-dark', error_class: ''
    end
  end

  config.wrappers :tom_select, tag: 'div', class: 'mb-6', error_class: 'form-group-invalid',
                               valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.use :label, class: LABEL_CLASSES
    b.use :input, data: { controller: 'tom-select' }

    b.use :full_error, wrap_with: { tag: 'div', class: 'block text-sm font-medium text-red-700 mt-1 max-w-fit' }
    b.use :hint, wrap_with: { tag: 'small', class: 'block text-sm font-medium text-gray-700 mt-1' }
  end
end

SimpleForm.setup do |config|
  config.default_wrapper = :default
  config.wrapper_mappings = {
    boolean: :boolean,
    radio_buttons: :radio_buttons
  }

  # Default configuration
  config.generate_additional_classes_for = []
  config.default_form_class = 'space-y-6'
  config.button_class = BUTTON_CLASSES
  config.label_text = ->(label, _required, _explicit_label) { label }

  config.error_notification_tag = :div
  config.error_notification_class = 'error_notification'
  config.error_method = :to_sentence

  config.browser_validations = false
  config.boolean_style = :inline
end
