import React, { useState } from 'react';
import { ChevronDown, ChevronUp } from 'lucide-react';

const FAQ = () => {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  const faqs = [
    {
      question: 'What is the Kelly Criterion?',
      answer: 'The Kelly Criterion is a mathematical formula developed by John L. Kelly Jr. at Bell Labs in 1956. It calculates the optimal size of a series of bets to maximize the logarithm of wealth over time. The formula determines what fraction of your bankroll to wager based on the odds and your probability of winning, helping to maximize long-term growth while minimizing the risk of ruin.'
    },
    {
      question: 'How do presets work in Kelly Stakes?',
      answer: 'Presets allow you to save different bankroll configurations and betting strategies. The free version includes 1 preset, perfect for most users. If you manage multiple bankrolls or use different strategies (like conservative vs aggressive approaches), you can purchase additional presets for $1.99 each. Switch between them instantly without re-entering your parameters.'
    },
    {
      question: 'Is my data completely private?',
      answer: 'Absolutely. Kelly Stakes performs all calculations locally on your device. We don\'t collect, store, or transmit any of your financial data, betting information, or calculations. There\'s no account creation required, no tracking, and no data ever leaves your phone. Your privacy and financial information remain completely secure.'
    },
    {
      question: 'How do I purchase additional presets?',
      answer: 'Additional presets are available as in-app purchases for $1.99 each. Simply tap the "Add Preset" button in the app, and you\'ll be prompted to complete the purchase through your App Store account. This is a one-time purchase per preset - no subscriptions or recurring fees. You can buy as many as you need.'
    },
    {
      question: 'What\'s the difference between American and Decimal odds?',
      answer: 'American odds (like +150 or -200) show how much you win relative to a $100 bet. Decimal odds (like 2.50) show your total return including your stake for every $1 bet. Kelly Stakes supports both formats plus fractional odds (like 3/2), automatically converting between them so you can use whichever format you\'re comfortable with.'
    },
    {
      question: 'Can I use Kelly Stakes for stock trading or investments?',
      answer: 'Yes! While designed for betting, the Kelly Criterion applies to any situation where you\'re making decisions about position sizing with uncertain outcomes. Many professional traders and investors use Kelly Criterion principles for portfolio allocation and risk management. Just input your expected return probability and potential gains/losses.'
    }
  ];

  return (
    <section id="faq" className="py-20 bg-gray-900">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl sm:text-4xl font-bold text-white mb-4">
            Frequently Asked Questions
          </h2>
          <p className="text-xl text-gray-300">
            Everything you need to know about Kelly Stakes and the Kelly Criterion.
          </p>
        </div>

        <div className="space-y-4">
          {faqs.map((faq, index) => (
            <div 
              key={index}
              className="bg-gray-800 border border-gray-700 rounded-xl overflow-hidden"
            >
              <button
                className="w-full text-left p-6 focus:outline-none focus:ring-2 focus:ring-green-500 hover:bg-gray-750 transition-colors duration-200"
                onClick={() => setOpenIndex(openIndex === index ? null : index)}
              >
                <div className="flex items-center justify-between">
                  <h3 className="text-lg font-semibold text-white pr-4">
                    {faq.question}
                  </h3>
                  {openIndex === index ? (
                    <ChevronUp className="w-5 h-5 text-green-500 flex-shrink-0" />
                  ) : (
                    <ChevronDown className="w-5 h-5 text-gray-400 flex-shrink-0" />
                  )}
                </div>
              </button>
              
              {openIndex === index && (
                <div className="px-6 pb-6">
                  <div className="w-full h-px bg-gray-700 mb-4"></div>
                  <p className="text-gray-300 leading-relaxed">
                    {faq.answer}
                  </p>
                </div>
              )}
            </div>
          ))}
        </div>

        <div className="mt-12 text-center">
          <p className="text-gray-400 mb-4">
            Still have questions?
          </p>
          <a 
            href="mailto:kellystakesapp@gmail.com"
            className="text-green-500 hover:text-green-400 font-semibold transition-colors duration-200"
          >
            Contact our support team
          </a>
        </div>
      </div>
    </section>
  );
};

export default FAQ;