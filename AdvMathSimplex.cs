using System;

namespace Extreme.Numerics.QuickStart.CSharp
{
    // The linear programming classes reside in a namespace with
    // other optimization-related classes.
    using Extreme.Mathematics.Optimization;
    // Vectors and matrices are in the Extreme.Mathematics
    // namespace
    using Extreme.Mathematics;

    /// <summary>
    /// Illustrates solving linear programming problems
    /// using the classes in the Extreme.Mathematics.Optimization
    /// namespace of the Extreme Optimization Numerical Libraries for .NET.
    /// </summary>
    class LinearProgramming
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            // This QuickStart Sample illustrates the three ways to create a Linear Program.

            // The first is in terms of matrices. The coefficients
            // are supplied as a matrix. The cost vector, right-hand side
            // and constraints on the variables are supplied as a vector.

            // The cost vector:
            var c = Vector.Create(-1.0, -3.0, 0.0, 0.0, 0.0, 0.0);
            // The coefficients of the constraints:
            var A = Matrix.Create(4, 6, new double[] 
            {
                1, 1, 1, 0, 0, 0,
                1, 1, 0, -1, 0, 0, 
                1, 0, 0, 0, 1, 0, 
                0, 1, 0, 0, 0, 1
            }, MatrixElementOrder.RowMajor);
            // The right-hand sides of the constraints:
            var b = Vector.Create(1.5, 0.5, 1.0, 1.0);

            // We're now ready to call the constructor.
            // The last parameter specifies the number of equality
            // constraints.
            LinearProgram lp1 = new LinearProgram(c, A, b, 4);

            // Now we can call the Solve method to run the Revised
            // Simplex algorithm:
            var x = lp1.Solve();
            // The GetDualSolution method returns the dual solution:
            var y = lp1.GetDualSolution();
            Console.WriteLine("Primal: {0:F1}", x);
            Console.WriteLine("Dual:   {0:F1}", y);
            // The optimal value is returned by the Extremum property:
            Console.WriteLine("Optimal value:   {0:F1}", lp1.OptimalValue);

            // The second way to create a Linear Program is by constructing
            // it by hand. We start with an 'empty' linear program.
            LinearProgram lp2 = new LinearProgram();

            // Next, we add two variables: we specify the name, the cost,
            // and optionally the lower and upper bound.
            lp2.AddVariable("X1", -1.0, 0, 1);
            lp2.AddVariable("X2", -3.0, 0, 1);

            // Next, we add constraints. Constraints also have a name.
            // We also specify the coefficients of the variables,
            // the lower bound and the upper bound.
            lp2.AddLinearConstraint("C1", Vector.Create(1.0, 1.0), 0.5, 1.5);
            // If a constraint is a simple equality or inequality constraint,
            // you can supply a LinearProgramConstraintType value and the
            // right-hand side of the constraint.

            // We can now solve the linear program:
            x = lp2.Solve();
            y = lp2.GetDualSolution();
            Console.WriteLine("Primal: {0:F1}", x);
            Console.WriteLine("Dual:   {0:F1}", y);
            Console.WriteLine("Optimal value:   {0:F1}", lp2.OptimalValue);

            // Finally, we can create a linear program from an MPS file.
            // The MPS format is a standard format.
            LinearProgram lp3 = MpsReader.Read(@"..\..\..\..\data\sample.mps");
            // We can go straight to solving the linear program:
            x = lp3.Solve();
            y = lp3.GetDualSolution();
            Console.WriteLine("Primal: {0:F1}", x);
            Console.WriteLine("Dual:   {0:F1}", y);
            Console.WriteLine("Optimal value:   {0:F1}", lp3.OptimalValue);

            Console.Write("Press Enter key to exit...");
            Console.ReadLine();
        }
    }
}