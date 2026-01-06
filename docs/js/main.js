jQuery(document).ready(function( $ ) {

  // Back to top button
  $(window).scroll(function() {
    if ($(this).scrollTop() > 100) {
      $('.back-to-top').fadeIn('slow');
    } else {
      $('.back-to-top').fadeOut('slow');
    }
  });
  $('.back-to-top').click(function(){
    $('html, body').animate({scrollTop : 0},1500, 'easeInOutExpo');
    return false;
  });

  // Header fixed on scroll
  $(window).scroll(function() {
    if ($(this).scrollTop() > 100) {
      $('#header').addClass('header-scrolled');
    } else {
      $('#header').removeClass('header-scrolled');
    }
  });

  if ($(window).scrollTop() > 100) {
    $('#header').addClass('header-scrolled');
  }

  // Real view height for mobile devices
  if (window.matchMedia("(max-width: 767px)").matches) {
    $('#intro').css({ height: $(window).height() });
  }

  // Initiate the wowjs animation library (needed for content visibility)
  new WOW().init();

  // Initialize Venobox
  $('.venobox').venobox({
    bgcolor: '',
    overlayColor: 'rgba(6, 12, 34, 0.85)',
    closeBackground: '',
    closeColor: '#fff'
  });

  // Initiate superfish on nav menu
  $('.nav-menu').superfish({
    animation: {
      opacity: 'show'
    },
    speed: 400
  });

  // Mobile Navigation
  if ($('#nav-menu-container').length) {
    var $mobile_nav = $('#nav-menu-container').clone().prop({
      id: 'mobile-nav'
    });
    $mobile_nav.find('> ul').attr({
      'class': '',
      'id': ''
    });
    $('body').append($mobile_nav);
    $('body').prepend('<button type="button" id="mobile-nav-toggle"><i class="fa fa-bars"></i></button>');
    $('body').append('<div id="mobile-body-overly"></div>');
    $('#mobile-nav').find('.menu-has-children').prepend('<i class="fa fa-chevron-down"></i>');

    $(document).on('click', '.menu-has-children i', function(e) {
      $(this).next().toggleClass('menu-item-active');
      $(this).nextAll('ul').eq(0).slideToggle();
      $(this).toggleClass("fa-chevron-up fa-chevron-down");
    });

    $(document).on('click', '#mobile-nav-toggle', function(e) {
      $('body').toggleClass('mobile-nav-active');
      $('#mobile-nav-toggle i').toggleClass('fa-times fa-bars');
      $('#mobile-body-overly').toggle();
    });

    $(document).click(function(e) {
      var container = $("#mobile-nav, #mobile-nav-toggle");
      if (!container.is(e.target) && container.has(e.target).length === 0) {
        if ($('body').hasClass('mobile-nav-active')) {
          $('body').removeClass('mobile-nav-active');
          $('#mobile-nav-toggle i').toggleClass('fa-times fa-bars');
          $('#mobile-body-overly').fadeOut();
        }
      }
    });
  } else if ($("#mobile-nav, #mobile-nav-toggle").length) {
    $("#mobile-nav, #mobile-nav-toggle").hide();
  }

  // Smooth scroll for the menu and links with .scrollto classes
  function scrollWithOffset(hash, animate) {
    var target = $(hash);
    if (!target.length) return;

    var header = $('#header');
    var base = header.length ? header.outerHeight() : 0;

    // Uniform offset so all sections land with same spacing as Registration
    var extra = -30;
    var top_space = Math.max(0, base + extra);
    var scrollTop = target.offset().top - top_space;
    if (animate) {
      $('html, body').animate({ scrollTop: scrollTop }, 600, 'easeInOutExpo');
    } else {
      $('html, body').scrollTop(scrollTop);
    }
  }

  $('.nav-menu a, #mobile-nav a, .scrollto').on('click', function() {
    if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
      var hash = this.hash;
      if (hash && $(hash).length) {
        scrollWithOffset(hash, true);

        if ($(this).parents('.nav-menu').length) {
          $('.nav-menu .menu-active').removeClass('menu-active');
          $(this).closest('li').addClass('menu-active');
        }

        if ($('body').hasClass('mobile-nav-active')) {
          $('body').removeClass('mobile-nav-active');
          $('#mobile-nav-toggle i').toggleClass('fa-times fa-bars');
          $('#mobile-body-overly').fadeOut();
        }
        return false;
      }
    }
  });

  // Adjust hash on load (direct link / refresh)
  if (window.location.hash) {
    var initialHash = window.location.hash;
    if ($(initialHash).length) {
      setTimeout(function() { scrollWithOffset(initialHash, false); }, 10);
    }
  }

  // Auto-select program day tab based on local deadlines (e.g., switch after 22:00 JST)
  (function selectProgramDay() {
    var $program = $('#detailed-program');
    if (!$program.length) return;

    var $tabs = $program.find('.nav-tabs a[data-deadline]');
    if (!$tabs.length) return;

    var now = Date.now();
    var chosen = null;

    $tabs.each(function() {
      var dl = $(this).data('deadline');
      if (!dl) return;
      var t = Date.parse(dl);
      if (isNaN(t)) return;
      if (t > now && (chosen === null || t < chosen.t)) {
        chosen = { t: t, el: this };
      }
    });

    if (!chosen) {
      chosen = { el: $tabs.first()[0] };
    }

    var $targetTab = $(chosen.el);
    if ($targetTab.hasClass('active')) return;

    $program.find('.nav-tabs a').removeClass('active');
    $targetTab.addClass('active');

    var targetPane = $targetTab.attr('href');
    $program.find('.tab-pane').removeClass('show active');
    $program.find(targetPane).addClass('show active');
  })();

  // Gallery carousel (uses the Owl Carousel library)
  $(".gallery-carousel").owlCarousel({
    autoplay: true,
    dots: true,
    loop: true,
    center:true,
    responsive: { 0: { items: 1 }, 768: { items: 3 }, 992: { items: 4 }, 1200: {items: 5}
    }
  });

  // Buy tickets select the ticket type on click
  $('#buy-ticket-modal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget);
    var ticketType = button.data('ticket-type');
    var modal = $(this);
    modal.find('#ticket-type').val(ticketType);
  })

// custom code

});
