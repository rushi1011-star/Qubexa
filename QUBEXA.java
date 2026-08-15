import java.util.Properties;
import java.util.Scanner;
import javax.mail.*;
import javax.mail.internet.*;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

class ClientManagementCollector {
    String name;
    String position;
    String help;
    String userEmail; 

    void clientReceiver() {
        Scanner scanner = new Scanner(System.in);

        System.out.println("============= WELCOME TO QUBEXA =============");              //javac -cp ".;*" QUBEXA.java; java -cp ".;*" QUBEXA
        
        System.out.print("ENTER YOUR NAME: ");
        name = scanner.nextLine();

        System.out.print("ENTER YOUR EMAIL: ");
        userEmail = scanner.nextLine(); 

        System.out.print("ENTER YOUR ROLE / POSITION: ");
        position = scanner.nextLine();

        System.out.print("HOW WILL HELP YOU: ");
        help = scanner.nextLine();
    }

    void sendEmails() {
        final String adminEmail = "rushikeshgomsale438@gmail.com"; 
        final String appPassword = "jhnt vpfm zyon ncta";  

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(adminEmail, appPassword);
            }
        });

        try {
            System.out.println("Email Will Be Sending...");

            Message adminMessage = new MimeMessage(session);
            adminMessage.setFrom(new InternetAddress(adminEmail));
            adminMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(adminEmail));
            adminMessage.setSubject("New Registration from: " + name);

            String adminBody = "New Client Details:\n\n"
                    + "Name: " + name + "\n"
                    + "Email: " + userEmail + "\n"
                    + "Position: " + position + "\n"
                    + "Contribution: " + help;

            adminMessage.setText(adminBody);
            Transport.send(adminMessage);

            Message userMessage = new MimeMessage(session);
            userMessage.setFrom(new InternetAddress(adminEmail));
            userMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail)); 
        
            String userBody = "Hello " + name + ",\n\n"
                    + "Thank you for reaching out to Qubexa!\n"
                    + "We have received your details:\n"
                    + "- Role: " + position + "\n"
                    + "- Help: " + help + "\n\n"
                    + "Our team will connect with you soon.\n\n"
                    + "Best Regards,\n"
                    + "Team Qubexa";

            userMessage.setText(userBody);
            Transport.send(userMessage);

            System.out.println("Data sent to Admin and Confirmation sent to " + userEmail);

        } catch (MessagingException e) {
            System.out.println("Email Will Not Be A Send" + e.getMessage());
        }
    }
}

public class QUBEXA {
    public static void main(String[] args) {
        ClientManagementCollector manage = new ClientManagementCollector();

        manage.clientReceiver();
        manage.sendEmails();
    }
}