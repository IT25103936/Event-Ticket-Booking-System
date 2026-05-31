package com.utils;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.File;
import java.io.FileOutputStream;

public class TicketPdfGenerator {

    public static String generateTicket(
            String bookingId,
            String eventName,
            String name,
            String date,
            String time,
            String location,
            String seats,
            String qty,
            String total,
            String paymentMethod
    ) {

        String folder = "C:/eventpass/tickets/";
        File dir = new File(folder);

        if (!dir.exists()) {
            dir.mkdirs();
        }

        String path = folder + "ticket_" + bookingId + ".pdf";

        try {
            // Document setup with compact margins
            Document doc = new Document(PageSize.A4, 54, 54, 54, 54);
            PdfWriter writer = PdfWriter.getInstance(doc, new FileOutputStream(path));
            doc.open();

            // --- COLOR PALETTE (Matched from UI) ---
            BaseColor primaryPurple = new BaseColor(123, 87, 244);     // #7B57F4
            BaseColor textMuted     = new BaseColor(127, 140, 150);    // Cool Gray labels
            BaseColor textDark      = new BaseColor(26, 37, 48);       // Near black for values
            BaseColor bgFooter      = new BaseColor(245, 247, 250);    // Off-white footer background

            // Status colors (Pill styling)
            String status = paymentMethod.equalsIgnoreCase("CASH") ? "PENDING" : "GENERATED";
            BaseColor badgeBg   = status.equals("PENDING") ? new BaseColor(254, 243, 199) : new BaseColor(219, 254, 234);
            BaseColor badgeText = status.equals("PENDING") ? new BaseColor(217, 119, 6)   : new BaseColor(21, 128, 61);

            // --- FONTS ---
            Font appTitleFont  = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, BaseColor.WHITE);
            Font eventTitleFont= FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, BaseColor.WHITE);
            Font headerTimeFont= FontFactory.getFont(FontFactory.HELVETICA, 11, new BaseColor(220, 210, 255));

            Font labelFont     = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, textMuted);
            Font valueFont     = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, textDark);

            Font priceLabelFont= FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11, textMuted);
            Font priceFont     = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, primaryPurple);
            Font statusFont    = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, badgeText);
            Font footerFont    = FontFactory.getFont(FontFactory.HELVETICA, 10, textMuted);

            // --- MAIN TICKET TABLE CONTAINER ---
            PdfPTable ticketCard = new PdfPTable(1);
            ticketCard.setWidthPercentage(100);

            // 1. PURPLE HEADER BANNER
            PdfPCell headerCell = new PdfPCell();
            headerCell.setBackgroundColor(primaryPurple);
            headerCell.setPaddingLeft(25);
            headerCell.setPaddingRight(25);
            headerCell.setPaddingTop(20);
            headerCell.setPaddingBottom(20);
            headerCell.setBorder(Rectangle.NO_BORDER);

            Paragraph appTag = new Paragraph("EVENTPASS • E-TICKET", appTitleFont);
            appTag.setSpacingAfter(6);
            headerCell.addElement(appTag);

            Paragraph eventTitle = new Paragraph(eventName, eventTitleFont);
            eventTitle.setSpacingAfter(4);
            headerCell.addElement(eventTitle);

            Paragraph eventDateTime = new Paragraph(date + ", " + time, headerTimeFont);
            headerCell.addElement(eventDateTime);

            ticketCard.addCell(headerCell);

            // 2. MAIN CONTENT BODY (White Grid Layout)
            PdfPCell bodyCell = new PdfPCell();
            bodyCell.setBackgroundColor(BaseColor.WHITE);
            bodyCell.setPadding(25);
            bodyCell.setBorder(Rectangle.LEFT | Rectangle.RIGHT);
            bodyCell.setBorderColor(new BaseColor(230, 235, 240));
            bodyCell.setBorderWidth(1f);

            PdfPTable infoGrid = new PdfPTable(2);
            infoGrid.setWidthPercentage(100);

            // Row 1: Seats & Quantity
            addMetaBlock(infoGrid, "SEATS", seats, labelFont, valueFont);
            addMetaBlock(infoGrid, "QUANTITY", qty + " Ticket(s)", labelFont, valueFont);

            // Spacer Row
            addEmptySpacerRow(infoGrid);

            // Row 2: Location & Payment Method
            addMetaBlock(infoGrid, "LOCATION", location, labelFont, valueFont);
            addMetaBlock(infoGrid, "PAYMENT", paymentMethod.toUpperCase(), labelFont, valueFont);

            bodyCell.addElement(infoGrid);
            ticketCard.addCell(bodyCell);

            // 3. DASHED SEPARATOR LINE CELL
            PdfPCell separatorCell = new PdfPCell();
            separatorCell.setBackgroundColor(BaseColor.WHITE);
            separatorCell.setPaddingLeft(25);
            separatorCell.setPaddingRight(25);
            // Border elements to maintain card structure sides
            separatorCell.setBorder(Rectangle.LEFT | Rectangle.RIGHT);
            separatorCell.setBorderColor(new BaseColor(230, 235, 240));
            separatorCell.setBorderWidth(1f);

            // Hook up custom cell event to draw the beautiful dashed line
            separatorCell.setCellEvent(new DashedLineCellEvent());
            separatorCell.setFixedHeight(15);
            ticketCard.addCell(separatorCell);

            // 4. PRICE & STATUS BADGE SECTION
            PdfPCell pricingCell = new PdfPCell();
            pricingCell.setBackgroundColor(BaseColor.WHITE);
            pricingCell.setPaddingLeft(25);
            pricingCell.setPaddingRight(25);
            pricingCell.setPaddingTop(15);
            pricingCell.setPaddingBottom(20);
            pricingCell.setBorder(Rectangle.LEFT | Rectangle.RIGHT);
            pricingCell.setBorderColor(new BaseColor(230, 235, 240));
            pricingCell.setBorderWidth(1f);

            PdfPTable priceGrid = new PdfPTable(2);
            priceGrid.setWidthPercentage(100);
            priceGrid.setWidths(new float[]{1.3f, 0.7f}); // Balance text and badge width

            // Left side: Price details
            PdfPCell priceLeft = new PdfPCell();
            priceLeft.setBorder(Rectangle.NO_BORDER);
            priceLeft.addElement(new Paragraph("TOTAL PAID", priceLabelFont));
            Paragraph priceVal = new Paragraph("LKR " + total, priceFont);
            priceVal.setSpacingBefore(4);
            priceLeft.addElement(priceVal);
            priceGrid.addCell(priceLeft);

            // Right side: Pill Status Badge
            PdfPCell priceRight = new PdfPCell();
            priceRight.setBorder(Rectangle.NO_BORDER);
            priceRight.setHorizontalAlignment(Element.ALIGN_RIGHT);
            priceRight.setVerticalAlignment(Element.ALIGN_MIDDLE);

            PdfPTable badgeTable = new PdfPTable(1);
            badgeTable.setHorizontalAlignment(Element.ALIGN_RIGHT);

            PdfPCell pill = new PdfPCell(new Phrase(status, statusFont));
            pill.setBackgroundColor(badgeBg);
            pill.setPaddingTop(6);
            pill.setPaddingBottom(6);
            pill.setPaddingLeft(14);
            pill.setPaddingRight(14);
            pill.setHorizontalAlignment(Element.ALIGN_CENTER);
            pill.setBorder(Rectangle.NO_BORDER);

            badgeTable.addCell(pill);
            priceRight.addElement(badgeTable);
            priceGrid.addCell(priceRight);

            pricingCell.addElement(priceGrid);
            ticketCard.addCell(pricingCell);

            // 5. FOOTER SUB-BAR (Booking ID & Issue Log)
            PdfPCell footerCell = new PdfPCell();
            footerCell.setBackgroundColor(bgFooter);
            footerCell.setPaddingLeft(25);
            footerCell.setPaddingRight(25);
            footerCell.setPaddingTop(12);
            footerCell.setPaddingBottom(12);
            footerCell.setBorder(Rectangle.BOX);
            footerCell.setBorderColor(new BaseColor(230, 235, 240));
            footerCell.setBorderWidth(1f);

            Paragraph footerText = new Paragraph("Booking ID: " + bookingId + "  •  Issued: " + date + ", " + time, footerFont);
            footerCell.addElement(footerText);
            ticketCard.addCell(footerCell);

            // Write final element card to document
            doc.add(ticketCard);
            doc.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return path;
    }

    // Helper to inject structured block fields cleanly
    private static void addMetaBlock(PdfPTable table, String label, String value, Font labelFont, Font valFont) {
        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.NO_BORDER);
        cell.addElement(new Paragraph(label, labelFont));

        Paragraph valueParagraph = new Paragraph(value, valFont);
        valueParagraph.setSpacingBefore(4);
        cell.addElement(valueParagraph);

        table.addCell(cell);
    }

    // Custom helper row to manage clean cell spacing inside standard tables
    private static void addEmptySpacerRow(PdfPTable table) {
        PdfPCell spacer = new PdfPCell(new Phrase(" "));
        spacer.setBorder(Rectangle.NO_BORDER);
        spacer.setFixedHeight(12);
        table.addCell(spacer);
        table.addCell(spacer);
    }

    // Custom iText Interface Callback to render a precise dotted line directly inside PDF Canvas layers
    private static class DashedLineCellEvent implements PdfPCellEvent {
        @Override
        public void cellLayout(PdfPCell cell, Rectangle position, PdfContentByte[] canvases) {
            PdfContentByte canvas = canvases[PdfPTable.LINECANVAS];
            canvas.saveState();
            canvas.setColorStroke(new BaseColor(210, 215, 225)); // soft separator tint
            canvas.setLineWidth(1.2f);
            canvas.setLineDash(4f, 4f, 0f); // Sets 4pt dashes with 4pt spaces
            canvas.moveTo(position.getLeft(), position.getBottom() + (position.getHeight() / 2));
            canvas.lineTo(position.getRight(), position.getBottom() + (position.getHeight() / 2));
            canvas.stroke();
            canvas.restoreState();
        }
    }
}