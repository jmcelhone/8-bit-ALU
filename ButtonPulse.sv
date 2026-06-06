module ButtonPulse #(
    // If button still double-presses, increase this to ~500,000 (10ms).
    parameter DEBOUNCE_LIMIT = 20'd50000 
)(
    input  logic clock,
    input  logic reset,
    input  logic button_in, // Active-low raw input from the physical button
    output logic pulse_out  // Active-high 1-cycle pulse
);

    // --- Stage 1: Synchronizer ---
    // Safely brings the asynchronous signal into our clock domain
    logic sync_0, sync_1;
    always_ff @(posedge clock or negedge reset) begin
        if (!reset) begin
            sync_0 <= 1'b1; // Default to unpressed (active-low)
            sync_1 <= 1'b1;
        end else begin
            sync_0 <= button_in;
            sync_1 <= sync_0;
        end
    end

    // --- Stage 2: Debouncer ---
    // Waits for the synchronized signal to stay perfectly stable 
    // for DEBOUNCE_LIMIT cycles before trusting it.
    logic [19:0] counter;
    logic debounced_state;
    
    always_ff @(posedge clock or negedge reset) begin
        if (!reset) begin
            counter <= '0;
            debounced_state <= 1'b1; // Default to unpressed
        end else begin
            if (sync_1 == debounced_state) begin
                counter <= '0; // Reset counter if the input matches our stable state
            end else begin
                counter <= counter + 1'b1;
                if (counter >= DEBOUNCE_LIMIT) begin
                    debounced_state <= sync_1; // Trust the new state
                    counter <= '0;
                end
            end
        end
    end

    // --- Stage 3: Edge Detector ---
    // Looks for the exact moment the button goes from Unpressed (1) to Pressed (0)
    logic last_state;
    always_ff @(posedge clock or negedge reset) begin
        if (!reset) begin
            last_state <= 1'b1;
        end else begin
            last_state <= debounced_state;
        end
    end

    // Output is exactly 1 when we transition from 1 -> 0
    assign pulse_out = (last_state == 1'b1) && (debounced_state == 1'b0);

endmodule
