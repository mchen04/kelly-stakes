import React from 'react';
import { BookOpen, TrendingUp, Shield, Target } from 'lucide-react';

const Education = () => {
  return (
    <section id="education" className="py-20 bg-gray-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl sm:text-4xl font-bold text-white mb-4">
            Master the Kelly Criterion
          </h2>
          <p className="text-xl text-gray-300 max-w-3xl mx-auto">
            Understanding the mathematics behind optimal position sizing will transform your approach to risk management.
          </p>
        </div>

        <div className="grid lg:grid-cols-2 gap-12 items-center">
          <div>
            <h3 className="text-2xl font-bold text-white mb-6">
              Why Optimal Sizing Matters
            </h3>
            
            <div className="space-y-6">
              <div className="flex items-start space-x-4">
                <div className="w-10 h-10 bg-green-500/20 rounded-lg flex items-center justify-center flex-shrink-0">
                  <TrendingUp className="w-5 h-5 text-green-500" />
                </div>
                <div>
                  <h4 className="text-lg font-semibold text-white mb-2">Maximize Long-term Growth</h4>
                  <p className="text-gray-400">
                    The Kelly Criterion mathematically maximizes the expected logarithm of wealth, 
                    leading to optimal long-term growth rates that outperform fixed betting strategies.
                  </p>
                </div>
              </div>

              <div className="flex items-start space-x-4">
                <div className="w-10 h-10 bg-blue-500/20 rounded-lg flex items-center justify-center flex-shrink-0">
                  <Shield className="w-5 h-5 text-blue-500" />
                </div>
                <div>
                  <h4 className="text-lg font-semibold text-white mb-2">Minimize Risk of Ruin</h4>
                  <p className="text-gray-400">
                    By never betting more than the Kelly-optimal fraction, you eliminate the mathematical 
                    possibility of losing your entire bankroll, no matter how many consecutive losses occur.
                  </p>
                </div>
              </div>

              <div className="flex items-start space-x-4">
                <div className="w-10 h-10 bg-orange-500/20 rounded-lg flex items-center justify-center flex-shrink-0">
                  <Target className="w-5 h-5 text-orange-500" />
                </div>
                <div>
                  <h4 className="text-lg font-semibold text-white mb-2">Data-Driven Decisions</h4>
                  <p className="text-gray-400">
                    Replace emotional decision-making with mathematical precision. Every bet size is 
                    calculated based on probability and expected value, not gut feelings or hunches.
                  </p>
                </div>
              </div>
            </div>
          </div>

          <div className="bg-gray-900 border border-gray-700 rounded-xl p-8">
            <div className="text-center mb-6">
              <BookOpen className="w-12 h-12 text-green-500 mx-auto mb-4" />
              <h3 className="text-xl font-bold text-white">Kelly Criterion Formula</h3>
            </div>

            <div className="bg-gray-800 rounded-lg p-6 mb-6">
              <div className="text-center mb-4">
                <div className="text-2xl font-mono text-green-500 mb-2">f* = (bp - q) / b</div>
              </div>
              
              <div className="space-y-2 text-sm text-gray-400">
                <div><strong className="text-white">f*</strong> = Fraction of capital to wager</div>
                <div><strong className="text-white">b</strong> = Odds received on the wager</div>
                <div><strong className="text-white">p</strong> = Probability of winning</div>
                <div><strong className="text-white">q</strong> = Probability of losing (1-p)</div>
              </div>
            </div>

            <div className="bg-gradient-to-r from-green-500/10 to-blue-500/10 border border-green-500/20 rounded-lg p-4">
              <h4 className="text-white font-semibold mb-2">Example Calculation:</h4>
              <p className="text-gray-300 text-sm">
                With 55% win probability and 2.0 decimal odds:<br/>
                f* = (1.0 × 0.55 - 0.45) / 1.0 = 0.10 or 10% of bankroll
              </p>
            </div>
          </div>
        </div>

        <div className="mt-16 text-center">
          <div className="bg-gradient-to-r from-gray-900 to-gray-800 border border-gray-700 rounded-xl p-8 max-w-4xl mx-auto">
            <h3 className="text-2xl font-bold text-white mb-4">
              Ready to Apply Kelly Criterion to Your Strategy?
            </h3>
            <p className="text-gray-300 text-lg mb-6">
              Start with the free version and experience the power of mathematical precision in your position sizing decisions.
            </p>
            
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <a 
                href="#download"
                className="bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-8 py-3 rounded-lg font-semibold transition-all duration-200"
              >
                Download Kelly Stakes
              </a>
              <a 
                href="mailto:kellystakesapp@gmail.com"
                className="border-2 border-blue-500 text-blue-400 hover:bg-blue-500 hover:text-white px-8 py-3 rounded-lg font-semibold transition-all duration-200"
              >
                Learn More Resources
              </a>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Education;