import React from 'react';
import { DollarSign, TrendingUp, Target } from 'lucide-react';

const HowItWorks = () => {
  const steps = [
    {
      icon: DollarSign,
      title: 'Enter Your Bankroll',
      description: 'Input your total available betting bankroll amount that you want to manage optimally.',
      color: 'text-green-500',
      bgColor: 'bg-green-500/10'
    },
    {
      icon: TrendingUp,
      title: 'Input Odds & Probability',
      description: 'Enter the betting odds and your estimated win probability for the specific opportunity.',
      color: 'text-blue-500',
      bgColor: 'bg-blue-500/10'
    },
    {
      icon: Target,
      title: 'Get Optimal Position Size',
      description: 'Receive the mathematically optimal bet size to maximize long-term growth while managing risk.',
      color: 'text-orange-500',
      bgColor: 'bg-orange-500/10'
    }
  ];

  return (
    <section id="how-it-works" className="py-20 bg-gray-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl sm:text-4xl font-bold text-white mb-4">
            How Kelly Stakes Works
          </h2>
          <p className="text-xl text-gray-300 max-w-3xl mx-auto">
            Three simple steps to calculate your optimal bet size using the Kelly Criterion mathematical formula.
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-8 relative">
          {steps.map((step, index) => (
            <div key={index} className="text-center relative">
              {index < steps.length - 1 && (
                <div className="hidden md:block absolute top-12 left-full w-full h-px bg-gradient-to-r from-gray-600 to-transparent transform translate-x-4"></div>
              )}
              
              <div className={`w-24 h-24 ${step.bgColor} rounded-full flex items-center justify-center mx-auto mb-6 relative`}>
                <step.icon className={`w-10 h-10 ${step.color}`} />
                <div className="absolute -top-2 -right-2 w-8 h-8 bg-gray-700 text-white rounded-full flex items-center justify-center text-sm font-bold">
                  {index + 1}
                </div>
              </div>
              
              <h3 className="text-xl font-bold text-white mb-4">{step.title}</h3>
              <p className="text-gray-400 leading-relaxed">{step.description}</p>
            </div>
          ))}
        </div>

        <div className="mt-16 bg-gray-800 border border-gray-700 rounded-xl p-8">
          <div className="text-center">
            <h3 className="text-2xl font-bold text-white mb-4">The Kelly Criterion Formula</h3>
            <div className="bg-gray-900 rounded-lg p-6 mb-6">
              <div className="text-center">
                <div className="text-3xl font-mono text-green-500 mb-2">f* = (bp - q) / b</div>
                <div className="text-gray-400 text-sm">
                  Where: f* = fraction of capital to wager, b = odds, p = probability of win, q = probability of loss
                </div>
              </div>
            </div>
            <p className="text-gray-300 max-w-2xl mx-auto">
              This mathematical formula, developed by John L. Kelly Jr. at Bell Labs, determines the optimal bet size 
              to maximize the logarithm of wealth over the long term while avoiding the risk of ruin.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default HowItWorks;