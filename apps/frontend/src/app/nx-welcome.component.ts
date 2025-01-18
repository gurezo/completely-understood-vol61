import { HttpClient } from '@angular/common/http';
import { Component, inject, ViewEncapsulation } from '@angular/core';

@Component({
  selector: 'app-nx-welcome',
  imports: [],
  template: ``,
  styles: [],
  encapsulation: ViewEncapsulation.None,
})
export class NxWelcomeComponent {
  private http = inject(HttpClient);

  inputValue: number | null = null;
  result: number | null = null;

  sendValue() {
    if (this.inputValue !== null) {
      this.http
        .post<{ doubled_value: number }>('http://127.0.0.1:8080/double', {
          value: this.inputValue,
        })
        .subscribe((response) => {
          this.result = response.doubled_value;
        });
    }
  }
}
