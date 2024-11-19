import { CoreMenu } from '@core/types';

export const menu: CoreMenu[] = [
 /*  {
    id: 'home',
    title: 'Home',
    translate: 'MENU.HOME',
    type: 'item',
    icon: 'home',
    url: 'home'
  },
  {
    id: 'sample',
    title: 'Sample',
    translate: 'MENU.SAMPLE',
    type: 'item',
    icon: 'file',
    url: 'sample'
  }, */
  {
    id: 'second',
    title: 'dashboard',
    type: 'item',
    icon: 'home',
    url: 'dashboard'
  },
  {
    id: 'third',
    title: 'User Management',
    type: 'item',
    icon: 'file',
    url: 'UserManagement'
  },
  {
    id: 'fourth',
    title: 'Agency Management',
    type: 'item',
    icon: 'file',
    url: 'AgencyManagement'
  },
  {
    id: 'fifth',
    title: 'Pending Agency Registrations',
    type: 'item',
    icon: 'file',
    url: 'PendingAgencyRegistrations'
  },
];
