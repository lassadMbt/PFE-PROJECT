import { Component, OnInit } from '@angular/core';
import { StatisticsService } from 'app/main/sample/services/statistics.service';

@Component({
  selector: 'app-user-management',
  templateUrl: './user-management.component.html',
  styleUrls: ['./user-management.component.scss']
})
export class UserManagementComponent implements OnInit {
  public users: any[] = [];
  public filteredUsers: any[] = [];
  public searchUser: string = '';

  constructor(private statisticsService: StatisticsService) {}

  ngOnInit() {
    this.loadUsers();
  }

  loadUsers() {
    this.statisticsService.getUsers().subscribe(
      (response: any) => {
        this.users = response.users; // Adjust according to your backend response structure
        this.filteredUsers = this.users;
      },
      (error) => {
        console.error('Error fetching users:', error);
      }
    );
  }

  filterUsers() {
    this.filteredUsers = this.users.filter(user =>
      user.name.toLowerCase().includes(this.searchUser.toLowerCase()) ||
      user.email.toLowerCase().includes(this.searchUser.toLowerCase())
    );
  }

  deleteUser(user) {
    if (confirm(`Are you sure you want to delete the user ${user.name}?`)) {
      this.statisticsService.deleteUser(user._id).subscribe(
        () => {
          this.loadUsers(); // Reload the users after deletion
        },
        (error) => {
          console.error('Error deleting user:', error);
        }
      );
    }
  }
}
