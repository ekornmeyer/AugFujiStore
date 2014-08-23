$( document ).ready(function() {
$('#copy_shipping').click(function() {
    var $this = $(this);
    // $this will contain a reference to the checkbox   
    if ($this.is(':checked')) {
        // the checkbox was checked 
        var address1 = $("#customer_shipping_address_sh_address1").val();
        $("#customer_billing_address_bi_address1").val(address1);
        var address2 = $("#customer_shipping_address_sh_address2").val();
        $("#customer_billing_address_bi_address2").val(address2);
        var city = $("#customer_shipping_address_sh_city").val();
        $("#customer_billing_address_bi_city").val(city);
        var state = $("#customer_shipping_address_sh_state").val();
        $("#customer_billing_address_bi_state").val(state);
        var zipcode = $("#customer_shipping_address_sh_zipcode").val();
        $("#customer_billing_address_bi_zipcode").val(zipcode);
    } else {
        // the checkbox was unchecked
        $("#customer_billing_address_bi_address1").val('');
        $("#customer_billing_address_bi_address2").val('');
        $("#customer_billing_address_bi_city").val('');
        $("#customer_billing_address_bi_state").val('');
        $("#customer_billing_address_bi_zipcode").val('');
    }
});

$("div[id^='asset-toolbar-options']").each(function(i) {
var theID = $(this).attr('id');
    $(this).prev('a').toolbar({
    content: '#' + theID,
    position: 'top',
    hideOnClick: 'true',
    zIndex: 99
});
});

$('input[id=asset_file_name]').change(function() {
    $('#assetCover').val($(this).val().replace('C:\\fakepath\\', ''));
});

$('.assetColumn').last().addClass('end');

  $("#sh_addresses_0").change(function(){
    var id = $(this).children(":selected").val();
    if (window.location.href.toLowerCase().indexOf("checkout") != -1) {

    var params = 'sh_addr_id=' + id;
    $.ajax({
      url: "/use_sh_address",
      data: params
    })
        } else {

    if(id == "") {
        $("#e_shipping_addresses").html("")
    } else {
    var params = 'sh_addr_id=' + id;
    $.ajax({
      url: "/get_sh_address",
      data: params
    })
}
}
});

  $("#bi_addresses_0").change(function(){
    var id2 = $(this).children(":selected").val();
    if (window.location.href.toLowerCase().indexOf("checkout") != -1) {

    var params2 = 'bi_addr_id=' + id2;
    $.ajax({
      url: "/use_bi_address",
      data: params2
    })
    } else {

    if(id2 == "") {
        $("#e_billing_addresses").html("")
    } else {
    var params2 = 'bi_addr_id=' + id2;
    $.ajax({
      url: "/get_bi_address",
      data: params2
    })
}
}
});  

  jQuery(function($){

    var jcrop_api;
    var realwidth = parseInt($('#realwidth').val());
    var realheight = parseInt($('#realheight').val());
    var afterwidth = parseInt($('#jcrop-original').css('width'));
    var afterheight = parseInt($('#jcrop-original').css('height'));
    var mag_max_w = parseInt(realwidth-afterwidth);    
    var mag_max_h = parseInt(realheight-afterheight);

    $('#jcrop-original').Jcrop({
      onChange:   showCoords,
      bgFade:     true,
      bgOpacity:  .2,      
      maxSize:    [mag_max_w,mag_max_h],      
      onSelect:   showCoords,
      trueSize:   [realwidth,realheight],
      onRelease:  clearCoords
    },function(){
      jcrop_api = this;
    });

    $('#coords').on('change','input',function(e){
      var x1 = $('#x1').val(),
          x2 = $('#x2').val(),
          y1 = $('#y1').val(),
          y2 = $('#y2').val();
      jcrop_api.setSelect([x1,y1,x2,y2]);
    });

  });

  // Simple event handler, called from onChange and onSelect
  // event handlers, as per the Jcrop invocation above
  function showCoords(c)
  {
    $('#x1').val(c.x);
    $('#y1').val(c.y);
    $('#x2').val(c.x2);
    $('#y2').val(c.y2);
    $('#w').val(c.w);
    $('#h').val(c.h);
  };

  function clearCoords()
  {
    $('#coords input').val('');
  };

$('#crop-image').click(function() {

    var x1 = $('#x1').val();
    var y1 = $('#y1').val();
    var w = $('#w').val();
    var h = $('#h').val();
    var assetid = $('#assetid').val();
    $.ajax({
      url: "/crop_image",
      data: {assetid: assetid, x1: x1, y1: y1, w: w, h: h}
    })
});

  $('.side-nav a').click(function(e) {
    var cid = $(this).attr("id");
    $.ajax({
      url: "/load_products",
      data: {category_id: cid}
    })    
    e.preventDefault();
  });

});