const transporter = require("../mailing/email")

const sendVerificationEmail = async (email, verificationCode) => {
    const mailOptions = {
        from: process.env.EMAIL_USER, // L'adresse email définie dans les variables d'environnement
        to: email,
        subject: 'Verification Code',
        text: `Your verification code is ${verificationCode}`,
    };

    try {
        await transporter.sendMail(mailOptions);
        console.log(`Verification code sent to ${email}`);
    } catch (error) {
        console.error('Error sending email:', error);
        throw new Error('Failed to send verification email');
    }
};

module.exports = sendVerificationEmail;