$(document).ready(function() {
  var $categories = $("dd.categories > ul > li");
  $categories.children("ul.secondary").hide();
  $categories.children("span.toggle_secondary").click(function() {
    var $this = $(this);
    $this.next("ul.secondary").slideToggle(200);
    $this.text($this.text() == "(more)" ? "(less)" : "(more)");
  });
});
