import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";

@Injectable({
  providedIn: "root",
})
export class StatisticsService {
  private baseUrl = "http://localhost:8080/admin"; // Replace with your backend URL

  constructor(private http: HttpClient) {}

  getGuestCount(): Observable<any> {
    return this.http.get(`${this.baseUrl}/count-guest`);
  }

  getUserCount(): Observable<any> {
    return this.http.get(`${this.baseUrl}/user-count`);
  }

  getAgencyCount(): Observable<any> {
    return this.http.get(`${this.baseUrl}/agency-count`);
  }

  getUsers(): Observable<any> {
    return this.http.get(`${this.baseUrl}/users`);
  }

  getAgencies(): Observable<any> {
    return this.http.get(`${this.baseUrl}/agencies`);
  }

  getPendingAgencyRegistrations(): Observable<any> {
    return this.http.get(`${this.baseUrl}/pending-agency-registrations`);
  }

  approveAgencyRegistration(id: string): Observable<any> {
    return this.http.get(`${this.baseUrl}/registered/${id}`);
  }

  login(credentials): Observable<any> {
    return this.http.post(`${this.baseUrl}/admin-login`,credentials);
  }

  rejectAgencyRegistration(id: string): Observable<any> {
    return this.http.get(`${this.baseUrl}/reject-agency-registration/${id}`);
  }
   // Add delete methods
   deleteUser(id: string): Observable<any> {
    return this.http.delete(`${this.baseUrl}/delete/${id}`);
  }

  deleteAgency(id: string): Observable<any> {
    return this.http.delete(`${this.baseUrl}/delete/${id}`);
  }
}