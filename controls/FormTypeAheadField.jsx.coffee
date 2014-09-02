###* @jsx React.DOM ###

React = require('react/addons')
Mixins = require('../mixins/Mixins')
TypeAheadMatchesList = require('./type_ahead/form_type_ahead_matches_list')
TypeAheadInput = require('./type_ahead/form_type_ahead_input')

TypeAheadField = React.createClass(
  mixins: [
    Mixins.DataSourcedMixin
    Mixins.ValidationMixin
    Mixins.StandardErrorDisplayMixin
    Mixins.DisableOnSubmitMixin
    Mixins.TypeAheadMixin
  ]

  propTypes:
    displayName: React.PropTypes.oneOfType([
      React.PropTypes.string, # Actual name
      React.PropTypes.bool    # false to disable
    ])
    dataKey: React.PropTypes.string.isRequired

  getInitialState: ->
    hiddenList: true
    highlightedIndex: -1
    item: @props.data ? {}
    options: []

  selectItem: (item) ->
    update =
      options: []
      hiddenList: true
      highlightedIndex: -1
      item: item

    @setState update, =>
      @props.onDataChanged(@props.dataKey, item.value ? item)

  render: ->
    size = if @props.displayName == false then 'col-sm-12' else 'col-sm-10'

    `(
      <div className={this.errorClasses('form-group', 'has-feedback')}>
        {this.renderLabel()}
        <div className={size}>
          <TypeAheadInput
            dataKey={this.props.dataKey}
            emptyList={this.state.hiddenList || this.state.options.length == 0}
            item={this.formattedItem()}
            free={this.props.free}
            disabled={this.disabled() || this.state.loadingItem}
            placeholder={this.props.placeholder}
            title={this.props.title}
            loading={this.state.loadingOptions || this.state.loadingItem}
            onChange={this.onChange}
            onFocus={this.onFocus}
            onBlur={this.onBlur}
            onKeyDown={this.onKeyDown}
            onKeyUp={this.onKeyUp}
          >
            <TypeAheadMatchesList
              ref="list"
              matches={this.state.options}
              highlightedIndex={this.state.highlightedIndex}
              hidden={this.state.hiddenList}
              onSelect={this.selectItem}
            />
            {this.errorSpan()}
          </TypeAheadInput>
        </div>
      </div>
    )`

)

module.exports = TypeAheadField