import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart';
import 'package:googleapis_auth/auth_io.dart';

class GetServerKey{
  static Future<String> getServerKeyToken() async{
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client= await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "roamtheworld-325c4",
          "private_key_id": "affb3bc097dcad211650e2cd93df1c4a8f0ca139",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCylB93g+C/Jw93\ndPURGMLEQETmhOm4fOEs984AYqFArVnZ04ri3X8AZWl6xLTRae4uQxwq26sEnSuX\nWhFaqGbWAjLFbNpH8eN7I0xEGOsKd0+Cs93CFia8HLzYcxy8eKyP6AndwNYa6xSq\n1nqC6sa/3qUB4Jr/nly0PNYE+UAjPpqEnvx9dQO7RS5InG295sgVk/1OSaWizMTx\nh3x+EV1GYCQyTfG58k+PRvf/0nknEKqYCnZM4zAK+k533aFalyyNUDuyL1sIz/96\njotGDPiarR5dKgekK/E8wgnGYzU0AhYj9xz/aIhgfYm9lwl4dkbw//ZCInMPkAOs\nnMCXf51JAgMBAAECggEAAV4WxRmokJIuIUQvJcG+qRXUaT8Ckq/7IfbmWBSpRzdk\noSFIdp8LXE+KgJ8Nwu5InYhUSIQ84ajJ9wtgp2Tzf6dN5/riy4r/ytc8++cEcsSx\n4k56D+TPSGDAdfhgs5VJfgMhAzaZNSTQeFPy5XqCieDcuuBTU4qNC3DNU0Ws3vA2\nJICm8G/Sz8Qgof4XKtnNm5tq3DAPNunueTSOOHs4Wq/nW7yhnWRrPgnoVaeWzj8I\nGqROdcw9ApphbWuYxs9MJ+64xfCD/FIermaze1AZoAfrDbWP+Aalp4y9ELcPhaGW\nAhmOyj3hwSe9tyJlj7lOeObqkYGGkO+MgFw35L5AoQKBgQDZeGCgTewFLi+Q88YA\n+OVIAzZ8O5gjbKcz8K5uqj9Oz8TJtDdUydqxQgaqtL/nNMqoEXuMVtokY62AAwcw\nM7emRwurDrJuQVKEA1C5XdcpYKQkVRHZPMf6gh+1z4RRhIxT7nKcp1s0O/XZUGSd\neRz0C2zp7tuZLC3CAFONQrHHaQKBgQDSN8T9M0phx/eB2l3V0E57FJWAw6vBmn7j\noaNXY4EJWJJGt/0OjDm5vZXOYJlRL4DPXVm/ww2LAE1dYeNpnKpdip48Q7MIR6jW\nsmhogM/jLkft6nNEvSdMg7oNV0bThRFT73l2kDOWTr3zsa7IhEtCmFphOxA8Kdg/\nCpqOuGNK4QKBgARqqHO5AWkdhgPIn6XXaDitMAcX4sAdbcvlQHWo6X49Q/7gtRr4\nuoNNFvuSji8w6Ei/iiXQgb+pcpWd+iBlfH5ZBQilVMReeUGLG7GYEU2a09qVC7bA\nwEL7L4+utj49legCeLtrvrNx4E1Yj6KPGiJutPiPTFBxEEDXZtsAlsG5AoGBAMqd\npEmj6RqMAXxwO6c9CpfJBDxC3MZTIeBHSEePiay3aO2uosMl1vG20LBFHSFKFu5H\nfJy+5MvIM8lA8081CGP2moNdgS8G2q5s8QNgvH6sefnP0uA7LKisAmSfbY2sIUJ0\ne+8SGBbUuHMtHFj6YgvDCsHSithiQKKqlsPe5x0hAoGAIpwzjO+pETUA4jZCyQis\naHUz0/P3xhVGroDx26N29hbCJs4Rk3baxj2XgFOm5p7DHxZO0+0Yvh4X1QU1/D7s\ne/ZAhJfydruW/3UxCLWWEUJtnw8A8k0kRNIDDeQDnp/AGaggIJg5bHYEUHKIY94/\nA3EwSxHyEgV35YsHBxWx72s=\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-fbsvc@roamtheworld-325c4.iam.gserviceaccount.com",
          "client_id": "114353152254778679880",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40roamtheworld-325c4.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
    ), scopes);
    final accessserverkey=client.credentials.accessToken.data;
    print("server key is $accessserverkey now end the key");
    return accessserverkey;
  }
}