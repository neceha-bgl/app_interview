# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
adjustment = null
last = $(".sortable_list > li").last().data("id")
$(".sortable_list").sortable
  group: 'users'
  pullPlaceholder: false
  onDrop: (item, targetContainer, _super) -> 
    clonedItem = $('<li/>').css height: 0
    item.before(clonedItem)
    clonedItem.animate 'height': item.height()
    
    item.animate clonedItem.position(), () ->
      clonedItem.detach()
      _super(item)
    
    id = item.data("id")
    next = item.next().data("id")
    $.post($(".sortable_list").data('update-url'), {"last":last, "id":id, "next":next})
  onDragStart: ($item, container, _super) -> 
    offset = $item.offset()
    pointer = container.rootGroup.pointer
    adjustment = 
      left: pointer.left - offset.left
      top: pointer.top - offset.top
    _super($item, container)
  onDrag: ($item, position) ->
    $item.css
      left: position.left - adjustment.left
      top: position.top - adjustment.top
