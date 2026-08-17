package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.web.bind.annotation.*;

class ClientRequest {
    private String name;
    private String userEmail;
    private String position;
    private String help;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getHelp() { return help; }
    public void setHelp(String help) { this.help = help; }
}

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class ContactController {

    @Autowired
    private JavaMailSender mailSender;

    @PostMapping("/register")
    public String registerUser(@RequestBody ClientRequest client) {
        String adminEmail = "rushikeshgomsale438@gmail.com";

        try {
            // १. ॲडमिनला जाणारा ईमेल
            SimpleMailMessage adminMsg = new SimpleMailMessage();
            adminMsg.setFrom(adminEmail);
            adminMsg.setTo(adminEmail);
            adminMsg.setSubject("New Registration from: " + client.getName());
            adminMsg.setText("New Client Details:\n\n"
                    + "Name: " + client.getName() + "\n"
                    + "Email: " + client.getUserEmail() + "\n"
                    + "Position: " + client.getPosition() + "\n"
                    + "Contribution: " + client.getHelp());
            mailSender.send(adminMsg);

            // २. युझरला जाणारा ईमेल (Confirmation)
            SimpleMailMessage userMsg = new SimpleMailMessage();
            userMsg.setFrom(adminEmail);
            userMsg.setTo(client.getUserEmail());
            userMsg.setSubject("Thank You for Joining Qubexa!");
            userMsg.setText("Hello " + client.getName() + ",\n\n"
                    + "Thank you for reaching out to Qubexa!\n"
                    + "We have received your details:\n"
                    + "- Role: " + client.getPosition() + "\n"
                    + "- Help: " + client.getHelp() + "\n\n"
                    + "Our team will connect with you soon.\n\n"
                    + "Best Regards,\n"
                    + "Team Qubexa");
            mailSender.send(userMsg);

            return "Email Sent Successfully!";
        } catch (Exception e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }
    }
}
