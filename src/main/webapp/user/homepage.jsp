<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>EventPass | Home </title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>

 <!-- Load CSS file -->
   <link rel="stylesheet" href="/eventTicketBookingSystem/css/userview/homepage.css">
</head>
<body>

  <!-- ─── NAVBAR ─── -->
<%@ include file="navbar.jsp" %>
  <!-- ─── HERO ─── -->
  <section class="hero">
    <div class="hero-badge">
        <span class="hero-badge-dot"></span>
        <span class="hero-badge-text">LIVE NOW &bull; SECURE YOUR SPOT</span>
    </div>
    <h1>Discover &amp; Book<br><span class="gradient-text">Unforgettable Events</span></h1>
    <p>From intimate concerts to massive festivals find, book and experience the moments that matter most.</p>
    <div class="hero-actions">
      <a href="<%= request.getContextPath() %>/user/dashboard.jsp" class="btn-hero-primary"><i class="bi bi-lightning-charge-fill me-2"></i>Get Start </a>

    </div>
    <div class="hero-stats">
      <div class="hero-stat"><div class="hero-stat-num">12K+</div><div class="hero-stat-lbl">Events Hosted</div></div>
      <div class="hero-stat"><div class="hero-stat-num">850K</div><div class="hero-stat-lbl">Tickets Sold</div></div>
      <div class="hero-stat"><div class="hero-stat-num">340+</div><div class="hero-stat-lbl">Venues</div></div>
      <div class="hero-stat"><div class="hero-stat-num">99%</div><div class="hero-stat-lbl">Happy Fans</div></div>
    </div>
  </section>

  <!-- ─── EVENTS ─── -->
 <section class="section-wrap" id="events">
   <div class="container">

     <!-- HEADER -->
     <div class="row align-items-end justify-content-between mb-4">
       <div class="col-auto">
         <div class="section-badge">Happening Soon</div>
         <h2 class="section-title">Upcoming Events</h2>
         <p class="section-sub">Secure your spot at the best experiences.</p>
       </div>

     </div>

     <!-- GRID -->
     <div class="row g-4">

       <!-- CARD -->
       <div class="col-xl-3 col-lg-4 col-md-6">
         <div class="event-card">

           <div class="img-stack">
             <img src="https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800"
                  class="event-img">

             <div class="category-pill">Music</div>

             <div class="calendar-box">
               <div class="mm">OCT</div>
               <div class="dd">24</div>
             </div>

             <div class="price-tag">$45</div>
           </div>

           <div class="card-content">
             <h4>Live Symphony</h4>

             <div class="event-meta">
               <i class="bi bi-geo-alt-fill"></i> Royal Opera Hall
             </div>

             <div class="event-meta">
               <i class="bi bi-clock"></i> 7:00 PM
             </div>

             <a href="tickets.jsp" class="btn-modern">
               <i class="bi bi-ticket-perforated"></i> Book Now
             </a>
           </div>

         </div>
       </div>

       <!-- COPY THIS BLOCK FOR MORE EVENTS -->

       <div class="col-xl-3 col-lg-4 col-md-6">
         <div class="event-card">
           <div class="img-stack">
             <img src="https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800" class="event-img">
             <div class="category-pill">Music</div>
             <div class="calendar-box"><div class="mm">JUL</div><div class="dd">08</div></div>
             <div class="price-tag">$55</div>
           </div>
           <div class="card-content">
             <h4>Jazz Night Live</h4>
             <div class="event-meta"><i class="bi bi-geo-alt-fill"></i> Colombo Jazz Club</div>
             <div class="event-meta"><i class="bi bi-clock"></i> 8:30 PM</div>
             <a href="tickets.jsp" class="btn-modern">Book Now</a>
           </div>
         </div>
       </div>

       <div class="col-xl-3 col-lg-4 col-md-6">
         <div class="event-card">
           <div class="img-stack">
             <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800" class="event-img">
             <div class="category-pill">Workshop</div>
             <div class="calendar-box"><div class="mm">AUG</div><div class="dd">14</div></div>
             <div class="price-tag">$30</div>
           </div>
           <div class="card-content">
             <h4>Design Workshop</h4>
             <div class="event-meta"><i class="bi bi-geo-alt-fill"></i> Hatch, Colombo</div>
             <div class="event-meta"><i class="bi bi-clock"></i> 10:00 AM</div>
             <a href="tickets.jsp" class="btn-modern">Join Now</a>
           </div>
         </div>
       </div>

       <div class="col-xl-3 col-lg-4 col-md-6">
         <div class="event-card">
           <div class="img-stack">
             <img src="https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800" class="event-img">
             <div class="category-pill">Business</div>
             <div class="calendar-box"><div class="mm">SEP</div><div class="dd">02</div></div>
             <div class="price-tag">$120</div>
           </div>
           <div class="card-content">
             <h4>Leadership Summit</h4>
             <div class="event-meta"><i class="bi bi-geo-alt-fill"></i> Shangri La</div>
             <div class="event-meta"><i class="bi bi-clock"></i> 9:00 AM</div>
             <a href="tickets.jsp" class="btn-modern">Register</a>
           </div>
         </div>
       </div>

     </div>
   </div>
 </section>
  <!-- ─── MARQUEE ─── -->
<div class="marquee-strip">
  <div class="marquee-inner">

    <!-- SET 1 -->
    <div class="marquee-item"><i class="bi bi-music-note-beamed"></i> Live Symphony</div>
    <div class="marquee-item"><i class="bi bi-music-note"></i> Jazz Night Live</div>
    <div class="marquee-item"><i class="bi bi-palette-fill"></i> Design Workshop</div>
    <div class="marquee-item"><i class="bi bi-people-fill"></i> Leadership Summit</div>
    <div class="marquee-item"><i class="bi bi-cup-hot-fill"></i> Street Food Carnival</div>
    <div class="marquee-item"><i class="bi bi-brightness-high-fill"></i> Lantern Festival</div>
    <div class="marquee-item"><i class="bi bi-activity"></i> Marathon 2026</div>
    <div class="marquee-item"><i class="bi bi-lightning-fill"></i> Rock Revolution</div>

    <!-- SET 2 (DUPLICATE for smooth loop) -->
    <div class="marquee-item"><i class="bi bi-music-note-beamed"></i> Live Symphony</div>
    <div class="marquee-item"><i class="bi bi-music-note"></i> Jazz Night Live</div>
    <div class="marquee-item"><i class="bi bi-palette-fill"></i> Design Workshop</div>
    <div class="marquee-item"><i class="bi bi-people-fill"></i> Leadership Summit</div>
    <div class="marquee-item"><i class="bi bi-cup-hot-fill"></i> Street Food Carnival</div>
    <div class="marquee-item"><i class="bi bi-brightness-high-fill"></i> Lantern Festival</div>
    <div class="marquee-item"><i class="bi bi-activity"></i> Marathon 2026</div>
    <div class="marquee-item"><i class="bi bi-lightning-fill"></i> Rock Revolution</div>

  </div>
</div>
  <!-- ─── FEATURED ─── -->
  <section class="section-wrap" id="featured">
    <div class="container">
      <div class="text-center mb-5 reveal">
        <div class="section-badge">Editor's Pick</div>
        <h2 class="section-title">Don't Miss This</h2>
      </div>

      <div class="featured-card reveal">
        <div class="row g-0 align-items-stretch">

          <div class="col-lg-5" style="overflow:hidden; min-height:380px">
            <img class="featured-img"
                 src="https://assets.simpleviewinc.com/simpleview/image/upload/c_limit,h_1200,q_75,w_1200/v1/clients/beaufortsc/LiveMusic_Concerts_5255d917-a3fc-4791-b94d-0b9b25c0c347.png"
                 loading="lazy" decoding="async"
                 alt="Music Festival"/>
          </div>

          <div class="col-lg-7">
            <div class="featured-body">

              <div class="featured-date">
                <i class="bi bi-calendar3"></i> Dec 20-22, 2026
              </div>

              <h2 class="featured-title">
                Neon Music<br>Festival 2026
              </h2>

              <p class="featured-desc">
                Experience an electrifying three day outdoor music festival featuring top international DJs,
                immersive light shows, and non-stop performances under the night sky.
              </p>

              <div class="featured-meta">
                <div class="featured-meta-item">
                  <label>Venue</label>
                  <p>Beach Arena, Colombo</p>
                </div>

                <div class="featured-meta-item">
                  <label>Duration</label>
                  <p>3 Nights</p>
                </div>

                <div class="featured-meta-item">
                  <label>From</label>
                  <p class="featured-price">$40.00</p>
                </div>
              </div>

              <div class="d-flex gap-3 flex-wrap">
                <a href="tickets.jsp" class="btn-hero-primary">
                  Reserve Seats <i class="bi bi-arrow-right ms-2"></i>
                </a>

                <a href="#" class="btn-hero-ghost">
                  Learn More
                </a>
              </div>

            </div>
          </div>

        </div>
      </div>
    </div>
  </section>
  <!-- ─── HOW IT WORKS ─── -->
  <section class="section-wrap" id="how">
    <div class="container">
      <div class="text-center mb-5 reveal">
        <div class="section-badge">Simple &amp; Fast</div>
        <h2 class="section-title">How It Works</h2>
        <p class="section-sub mx-auto">Three steps between you and the best night of your life.</p>
      </div>
      <div class="row g-4">
        <div class="col-md-4 reveal">
          <div class="step-card">
            <div class="step-num">Step 01</div>
            <div class="step-icon-wrap"><i class="bi bi-search"></i></div>
            <div class="step-title">Discover Events</div>
            <div class="step-desc">Browse thousands of events by category, location, or date. Smart filters help you find the perfect experience instantly.</div>
          </div>
        </div>
        <div class="col-md-4 reveal">
          <div class="step-card">
            <div class="step-num">Step 02</div>
            <div class="step-icon-wrap"><i class="bi bi-ticket-perforated"></i></div>
            <div class="step-title">Pick Your Seats</div>
            <div class="step-desc">Interactive seating maps let you choose exactly where you sit. Compare ticket tiers and lock in the best deal before they sell out.</div>
          </div>
        </div>
        <div class="col-md-4 reveal">
          <div class="step-card">
            <div class="step-num">Step 03</div>
            <div class="step-icon-wrap"><i class="bi bi-phone"></i></div>
            <div class="step-title">Scan &amp; Enjoy</div>
            <div class="step-desc">Receive your e-tickets instantly. Just scan your phone at the gate - no printing, no queues, no stress at all.</div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ─── TESTIMONIALS ─── -->
  <section class="section-wrap">
    <div class="container">
      <div class="text-center mb-5 reveal">
        <div class="section-badge">Fan Reviews</div>
        <h2 class="section-title">What People Say</h2>
      </div>
      <div class="row g-4">
        <div class="col-md-4 reveal">
          <div class="testi-card">
            <div class="testi-stars">
              <i class="bi bi-star-fill"></i>
              <i class="bi bi-star-fill"></i>
              <i class="bi bi-star-fill"></i>
              <i class="bi bi-star-fill"></i>
            </div>
            <div class="testi-text">Bought tickets in under two minutes. The seat picker is incredibly smooth and my e-tickets arrived instantly. Will never use another platform.</div>
            <div class="testi-author"><div class="testi-avatar">NK</div><div><div class="testi-name">Nimal Kumarasinghe</div><div class="testi-role">Festival-goer, Colombo</div></div></div>
          </div>
        </div>
        <div class="col-md-4 reveal">
          <div class="testi-card">
           <div class="testi-stars">
             <i class="bi bi-star-fill"></i>
             <i class="bi bi-star-fill"></i>
             <i class="bi bi-star-fill"></i>
             <i class="bi bi-star-fill"></i>
             <i class="bi bi-star-fill"></i>
           </div>
            <div class="testi-text">EventPass made organizing group tickets for 12 people completely effortless. Customer support was also outstanding when we had a question.</div>
            <div class="testi-author"><div class="testi-avatar">DW</div><div><div class="testi-name">Dilani Wickramasinghe</div><div class="testi-role">Event organizer, Kandy</div></div></div>
          </div>
        </div>
        <div class="col-md-4 reveal">
          <div class="testi-card">
            <div class="testi-stars">
              <i class="bi bi-star-fill"></i>
              <i class="bi bi-star-fill"></i>
              <i class="bi bi-star-fill"></i>
              <i class="bi bi-star-fill"></i>
              <i class="bi bi-star-fill"></i>
            </div>
            <div class="testi-text">Best ticket booking experience in Sri Lanka. The early bird alerts are a killer feature — I scored front-row seats for half price!</div>
            <div class="testi-author"><div class="testi-avatar">AJ</div><div><div class="testi-name">Ashen Jayawardena</div><div class="testi-role">Music fan, Galle</div></div></div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ─── NEWSLETTER ─── -->
  <section class="section-wrap">
    <div class="container">
      <div class="newsletter-card reveal">
        <div class="section-badge">Stay Updated</div>
        <h2>Never Miss an Event</h2>
        <p>Get early bird alerts, exclusive deals, and event announcements straight to your inbox.</p>
        <div class="newsletter-input">
          <input type="email" placeholder="Enter your email address…"/>
          <button><i class="bi bi-envelope-check me-1"></i> Subscribe</button>
        </div>
      </div>
    </div>
  </section>

  <!-- ─── FOOTER ─── -->
  <%@ include file="footer.jsp" %>

  <script defer src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    document.querySelectorAll('.filter-pill').forEach(p => {
      p.addEventListener('click', () => {
        document.querySelectorAll('.filter-pill').forEach(x => x.classList.remove('active'));
        p.classList.add('active');
      });
    });

    const obs = new IntersectionObserver((entries) => {
      entries.forEach((e, i) => {
        if (e.isIntersecting) {
          setTimeout(() => e.target.classList.add('visible'), i * 90);
          obs.unobserve(e.target);
        }
      });
    }, { threshold: 0.1 });
    document.querySelectorAll('.reveal').forEach(r => obs.observe(r));
  </script>
</body>
</html>