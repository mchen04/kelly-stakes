import { extensionAmericanToDecimal as americanToDecimal, impliedPercentage as calculateImpliedOdds } from '@kelly-stakes/kelly';

document.addEventListener('DOMContentLoaded', function() {
  const newKellyBankrollInput = document.getElementById('newKellyBankroll');
  const newKellyMultiplierInput = document.getElementById('newKellyMultiplier');
  const projectedOddsInput = document.getElementById('projectedOdds');
  const offeredOddsInput = document.getElementById('offeredOdds');
  const calculateKellyButton = document.getElementById('calculateKellyButton');
  const optimalBetPercentageSpan = document.getElementById('optimalBetPercentage');
  const recommendedWagerAmountSpan = document.getElementById('recommendedWagerAmount');
  
  // Load saved values from storage
  loadSavedValues();
  
  // Add event listeners
  calculateKellyButton.addEventListener('click', calculateAndDisplayKelly);
  newKellyBankrollInput.addEventListener('input', saveNewKellyBankroll);
  newKellyMultiplierInput.addEventListener('input', saveNewKellyMultiplier);
  
  // Function to save bankroll to chrome.storage
  function saveNewKellyBankroll() {
    chrome.storage.local.set({
      'newKellyBankroll': newKellyBankrollInput.value
    });
  }

  // Function to save Kelly multiplier to chrome.storage
  function saveNewKellyMultiplier() {
    chrome.storage.local.set({
      'newKellyMultiplier': newKellyMultiplierInput.value
    });
  }
  
  // Function to load saved values from chrome.storage
  function loadSavedValues() {
    chrome.storage.local.get([
      'newKellyBankroll',
      'newKellyMultiplier'
    ], function(result) {
      // Load bankroll from storage, or set default to 4000
      if (result.newKellyBankroll) {
        newKellyBankrollInput.value = result.newKellyBankroll;
      } else {
        newKellyBankrollInput.value = 4000;
      }
      
      // Load Kelly multiplier from storage, or set default to 1.0
      if (result.newKellyMultiplier) {
        newKellyMultiplierInput.value = result.newKellyMultiplier;
      } else {
        newKellyMultiplierInput.value = 1.0;
      }
    });
  }

  // Main Kelly calculation function
  function calculateAndDisplayKelly() {
    const projectedOdds = projectedOddsInput.value.trim();
    const offeredOdds = offeredOddsInput.value.trim();

    if (!projectedOdds || !offeredOdds) {
      optimalBetPercentageSpan.textContent = 'Please enter both odds.';
      recommendedWagerAmountSpan.textContent = 'N/A';
      return;
    }

    const bankroll = parseFloat(newKellyBankrollInput.value) || 4000;
    const kellyMultiplier = parseFloat(newKellyMultiplierInput.value) || 1.0;

    // Convert American odds to decimal odds
    const bookDecimalOdds = americanToDecimal(offeredOdds);
    const actualProb = calculateImpliedOdds(projectedOdds) / 100; // Projected odds are true odds

    if (isNaN(bookDecimalOdds) || isNaN(actualProb) || actualProb <= 0) {
      optimalBetPercentageSpan.textContent = 'Invalid odds entered.';
      recommendedWagerAmountSpan.textContent = 'N/A';
      return;
    }

    const b = bookDecimalOdds - 1;
    const p = actualProb;
    const q = 1.0 - p;

    let kellyFraction = 0;
    if (b > 0) { // Avoid division by zero
      kellyFraction = ((b * p) - q) / b;
    }

    const optimalBetPercent = Math.max(0, kellyFraction * kellyMultiplier);
    const recommendedWager = (optimalBetPercent * bankroll).toFixed(2);

    optimalBetPercentageSpan.textContent = `${(optimalBetPercent * 100).toFixed(2)}%`;
    recommendedWagerAmountSpan.textContent = `$${recommendedWager}`;
  }

  // Helper function to convert American odds to decimal odds
  

  // Helper function to calculate implied probability from American odds
  
});
