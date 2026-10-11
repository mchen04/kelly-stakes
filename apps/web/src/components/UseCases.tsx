import React from 'react';
import { TrendingUp, Target, PieChart, GraduationCap } from 'lucide-react';

const UseCases = () => {
  const useCases = [
    {
      icon: TrendingUp,
      title: 'Sports Betting',
      description: 'Professional bankroll management for NFL, NBA, MLB, NHL, and more. Input American or decimal odds directly - no conversion needed.',
      color: 'text-green-500'
    },
    {
      icon: Target,
      title: 'Live Betting',
      description: 'Quick calculations for in-play betting when lines move fast. Save presets for different sports and adjust Kelly fraction on the fly.',
      color: 'text-blue-500'
    },
    {
      icon: PieChart,
      title: 'Multi-Sport Bankroll',
      description: 'Manage separate bankrolls for different sports or betting strategies. Switch between conservative and aggressive Kelly fractions.',
      color: 'text-orange-500'
    },
    {
      icon: GraduationCap,
      title: 'Sharp Betting Education',
      description: 'Learn why professional bettors use Kelly Criterion. Understand optimal bet sizing and avoid the common mistake of overbetting.',
      color: 'text-purple-500'
    }
  ];

  return (
    <section id="use-cases" className="py-20 bg-gray-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl sm:text-4xl font-bold text-white mb-4">
            Perfect For
          </h2>
          <p className="text-xl text-gray-300 max-w-3xl mx-auto">
            Kelly Stakes is the ideal tool for anyone who wants to make mathematically optimal decisions about position sizing and risk management.
          </p>
        </div>

        <div className="grid md:grid-cols-2 gap-8">
          {useCases.map((useCase, index) => (
            <div 
              key={index}
              className="bg-gray-800 border border-gray-700 rounded-xl p-8 hover:border-gray-600 transition-all duration-300 group"
            >
              <div className="flex items-start space-x-4">
                <div className={`w-12 h-12 rounded-lg bg-gray-900 flex items-center justify-center ${useCase.color} group-hover:scale-110 transition-transform duration-300`}>
                  <useCase.icon className="w-6 h-6" />
                </div>
                
                <div className="flex-1">
                  <h3 className="text-xl font-bold text-white mb-3">{useCase.title}</h3>
                  <p className="text-gray-400 leading-relaxed">{useCase.description}</p>
                </div>
              </div>
            </div>
          ))}
        </div>

        <div className="mt-16 text-center">
          <div className="bg-gradient-to-r from-gray-800 to-gray-700 border border-gray-600 rounded-xl p-8">
            <h3 className="text-2xl font-bold text-white mb-4">
              Why Mathematical Position Sizing Matters
            </h3>
            <p className="text-gray-300 text-lg max-w-4xl mx-auto leading-relaxed">
              The Kelly Criterion is a mathematical formula that calculates optimal bet sizing based on your edge 
              and the odds. It maximizes long-term geometric growth rate—but only when you truly know your edge. 
              Important: Kelly betting is volatile (33% chance of halving your bankroll before doubling it) and 
              requires accurate probability estimates. Most professionals use fractional Kelly (25-50% of full Kelly) 
              to reduce variance while maintaining positive expected growth.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default UseCases;