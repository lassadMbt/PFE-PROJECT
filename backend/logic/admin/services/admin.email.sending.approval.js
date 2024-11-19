const nodemailer = require("nodemailer");
const AUTH = require("../../../models/AuthModel");

// Create a transporter object using SMTP transport
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "Put your email here",
    pass: "put your Password here",
  },
});

// Function to send email
const sendEmail = async (to, subject, text) => {
  try {
    // Send mail with defined transport object
    await transporter.sendMail({
      from: "Put your email here",
      to: to,
      subject: subject,
      text: text,
    });
    console.log("Email sent successfully");
  } catch (error) {
    console.error("Error sending email:", error);
    throw error;
  }
};

module.exports = {
    sendEmail
}