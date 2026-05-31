<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>

/* FOOTER WRAPPER */
.footer {
    margin-left: 240px;
    padding: 18px 25px;

    background: #ffffff;

    display: flex;
    justify-content: space-between;
    align-items: center;

    border-radius: 14px 14px 0 0;

    box-shadow: 0 -8px 30px rgba(0,0,0,0.08);

    font-size: 13px;
    color: #666;

    transition: all 0.3s ease;
}

/* LEFT SECTION */
.footer-left {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.footer-left .brand {
    font-size: 14px;
    font-weight: 600;
    color: #6c5ce7;
}

.footer-left .sub {
    font-size: 12px;
    color: #888;
}

/* RIGHT LINKS */
.footer-right {
    display: flex;
    gap: 14px;
}

.footer-right a {
    text-decoration: none;
    color: #666;
    font-size: 13px;

    transition: 0.3s;
    position: relative;
}

/* HOVER UNDERLINE ANIMATION */
.footer-right a::after {
    content: "";
    position: absolute;
    left: 0;
    bottom: -3px;

    width: 0%;
    height: 2px;

    background: #6c5ce7;

    transition: 0.3s;
}

.footer-right a:hover {
    color: #6c5ce7;
}

.footer-right a:hover::after {
    width: 100%;
}

/* SOCIAL ICONS */
.footer-social {
    display: flex;
    gap: 10px;
    margin-left: 20px;
}

.footer-social i {
    font-size: 16px;
    color: #888;
    cursor: pointer;
    transition: 0.3s;
}

.footer-social i:hover {
    color: #6c5ce7;
    transform: translateY(-2px);
}

/* RESPONSIVE */
@media (max-width: 768px) {
    .footer {
        margin-left: 200px;
        flex-direction: column;
        text-align: center;
        gap: 10px;
    }

    .footer-right {
        justify-content: center;
        flex-wrap: wrap;
    }
}

</style>

<div class="footer">

    <!-- LEFT SIDE -->
    <div class="footer-left">

        <div class="sub">Online Event Ticket Booking System © 2026
                             </div>
    </div>

    <!-- RIGHT SIDE LINKS -->
    <div class="footer-right">
        <a href="#">Privacy Policy</a>
        <a href="#">Terms</a>
        <a href="#">Support</a>
        <a href="#">Contact</a>
    </div>

    <!-- SOCIAL ICONS -->
    <div class="footer-social">
        <i class="bi bi-facebook"></i>
        <i class="bi bi-twitter"></i>
        <i class="bi bi-github"></i>
        <i class="bi bi-envelope"></i>
    </div>

</div>