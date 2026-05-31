package com.model;

 public class Seat {

        private int id;
        private int eventId;
        private int seatNo;
        private String seatType;
        private boolean booked;


        public Seat(int id, int eventId, int seatNo,
                    String seatType, boolean booked) {

            this.id = id;
            this.eventId = eventId;
            this.seatNo = seatNo;
            this.seatType = seatType;
            this.booked = booked;

        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }


        public int getEventId() {
            return eventId;
        }

        public void setEventId(int eventId) {
            this.eventId = eventId;
        }


        public int getSeatNo() {
            return seatNo;
        }

        public void setSeatNo(int seatNo) {
            this.seatNo = seatNo;
        }


        public String getSeatType() {
            return seatType;
        }

        public void setSeatType(String seatType) {
            this.seatType = seatType;
        }

        public boolean isBooked() {
            return booked;
        }

        public void setBooked(boolean booked) {
            this.booked = booked;
        }



        // file format:
        // id,eventId,seatNo,seatType,booked,price
        public String toFileString() {

            return id + "," + eventId + "," + seatNo + "," +
                    seatType + "," + booked ;
        }

}
