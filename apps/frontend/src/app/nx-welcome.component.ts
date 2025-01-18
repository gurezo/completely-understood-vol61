import { HttpClient } from '@angular/common/http';
import { Component, inject, ViewEncapsulation } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-nx-welcome',
  imports: [FormsModule],
  template: `
    <div style="text-align: center; margin-top: 50px;">
      <h1>Double Value App</h1>
      <input
        [(ngModel)]="inputValue"
        type="number"
        placeholder="Enter a number"
      />
      <button (click)="sendValue()">Send</button>
      @if (result !== null) {
      <p>No Calculate</p>
      } @else {
      <p>Result: {{ result }}</p>
      }
    </div>
  `,
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
