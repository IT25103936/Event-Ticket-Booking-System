<footer class="modern-footer mt-auto">
    <div class="container">
        <div class="row g-4 mb-4">

            <div class="col-lg-4 col-md-6">
                <div class="footer-brand mb-3">
                    <div class="brand-dot"></div>
                    <h5 class="fw-bold mb-0">Event<span class="text-primary">Pass</span></h5>
                </div>
                <p class="footer-description">
                    Empowering event organizers and attendees with a seamless,
                    secure, and modern booking experience.
                </p>
                <div class="footer-contact">
                    <span class="d-block"><i class="bi bi-envelope-at me-2 text-primary"></i>support@eventpass.com</span>
                </div>
            </div>

            <div class="col-lg-4 col-md-6 px-lg-5">
                <h6 class="footer-heading">Navigation</h6>
                <div class="row row-cols-2 g-2">
                    <div class="col">
                        <a href="dashboard.jsp" class="footer-link">Dashboard</a>
                    </div>
                    <div class="col">
                        <a href="events.jsp" class="footer-link">Events</a>
                    </div>
                    <div class="col">
                        <a href="myBooking.jsp" class="footer-link">Bookings</a>
                    </div>
                    <div class="col">
                        <a href="profile.jsp" class="footer-link">Profile</a>
                    </div>
                    <div class="col">
                        <a href="tickets.jsp" class="footer-link">My Tickets</a>
                    </div>
                    <div class="col">
                        <a href="history.jsp" class="footer-link">Logs</a>
                    </div>
                </div>
            </div>

            <div class="col-lg-4 col-md-12">
                <h6 class="footer-heading">Connect With Us</h6>
                <div class="social-group">
                    <a href="#" class="social-btn facebook"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="social-btn instagram"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="social-btn twitter"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="social-btn linkedin"><i class="bi bi-linkedin"></i></a>
                </div>
                <div class="mt-4">
                    <p class="footer-tagline">Stay updated with the latest events.</p>
                </div>
            </div>
        </div>

        <hr class="footer-divider">

        <div class="row align-items-center py-3">
            <div class="col-md-6 text-center text-md-start">
                <p class="copyright mb-0">
                    &copy; <%= java.time.Year.now() %> <span class="fw-semibold">EventPass</span>. All rights reserved.
                </p>
            </div>
            <div class="col-md-6 text-center text-md-end mt-2 mt-md-0">
                <div class="footer-legal-links">
                    <a href="#">Privacy Policy</a>
                    <span class="mx-2">|</span>
                    <a href="#">Terms of Service</a>
                </div>
            </div>
        </div>
    </div>
</footer>

<style>
/* FOOTER BASE */
.modern-footer {
    background: #0f172a; /* Deep slate - very modern dark color */
    color: #94a3b8;
    padding: 40px 0 20px 0;
    font-family: 'Inter', sans-serif;
}

.footer-description {
    font-size: 0.95rem;
    line-height: 1.6;
    color: #94a3b8;
}

.footer-heading {
    color: #f8fafc;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.8rem;
    letter-spacing: 1px;
    margin-bottom: 1.5rem;
}

/* BRANDING */
.footer-brand {
    display: flex;
    align-items: center;
    gap: 10px;
}

.footer-brand h5 {
    color: #f8fafc;
    letter-spacing: -0.5px;
}

.brand-dot {
    width: 10px;
    height: 10px;
    background: #6366f1;
    border-radius: 50%;
}

/* LINKS */
.footer-link {
    color: #94a3b8;
    text-decoration: none;
    font-size: 0.9rem;
    transition: all 0.2s ease;
    display: inline-block;
}

.footer-link:hover {
    color: #6366f1;
    transform: translateX(3px);
}

/* SOCIAL BUTTONS */
.social-group {
    display: flex;
    gap: 12px;
}

.social-btn {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #1e293b;
    color: #94a3b8;
    font-size: 1.1rem;
    text-decoration: none;
    transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.social-btn:hover {
    transform: translateY(-5px);
    color: white;
}

.social-btn.facebook:hover { background: #1877F2; }
.social-btn.instagram:hover { background: #E4405F; }
.social-btn.twitter:hover { background: #000000; }
.social-btn.linkedin:hover { background: #0A66C2; }

/* DIVIDER & COPYRIGHT */
.footer-divider {
    border-color: rgba(255,255,255,0.05);
    margin: 2rem 0;
}

.copyright {
    font-size: 0.85rem;
}

.footer-legal-links a {
    color: #64748b;
    text-decoration: none;
    font-size: 0.85rem;
    transition: color 0.2s;
}

.footer-legal-links a:hover {
    color: #f8fafc;
}

.footer-tagline {
    font-size: 0.8rem;
    font-style: italic;
    opacity: 0.7;
}
</style>