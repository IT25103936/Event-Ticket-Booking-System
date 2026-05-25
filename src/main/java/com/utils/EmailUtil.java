package com.utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.File;
import java.util.Properties;

public class EmailUtil {

    private static final String FROM_EMAIL = "samithasenewiratna@gmail.com";
    private static final String PASSWORD = "bnuf iykj plio tilo";

    public static boolean sendTicketEmail(
            String to,
            String subject,
            String htmlBody,
            String pdfPath
    ) {

        try {

            Properties props = new Properties();

            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");

            Session session = Session.getInstance(
                    props,
                    new Authenticator() {
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(
                                    FROM_EMAIL,
                                    PASSWORD
                            );
                        }
                    }
            );

            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(to)
            );

            message.setSubject(subject);

            // EMAIL BODY (HTML)
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setContent(htmlBody, "text/html");

            // ATTACHMENT (PDF)
            MimeBodyPart filePart = new MimeBodyPart();
            filePart.attachFile(new File(pdfPath));

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(textPart);
            multipart.addBodyPart(filePart);

            message.setContent(multipart);

            Transport.send(message);

            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}