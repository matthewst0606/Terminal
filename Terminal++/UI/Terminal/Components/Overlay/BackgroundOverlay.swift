//
//  BackgroundJobsView.swift
//  Terminal++
//
//  Created by Matt on 7/9/26.
//
// placeholder content for what will eventually show what
// background jobs are running from rust

import SwiftUI

struct BackgroundJobsView: View {

    private let jobs = [
        ("Shell", "Idle",           "terminal.fill"              ),
        ("Index", "Watching",       "arrow.triangle.2.circlepath"),
        ("Build", "No active task", "hammer.fill"                )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            HStack(content: {
                Text("Background Jobs")
                    .font(.headline)
                
                Spacer()
                
                Text("\(jobs.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            })
            
            VStack(content: {
                ForEach(jobs, id: \.0) { job in
                    DisplayJobRow(
                        title:  job.0,
                        status: job.1,
                        symbol: job.2
                    )
                }
            })
            .backgroundRect(panel, radius: 24)
            
        })
        .padding(14)
        .frame(width: 280, alignment: .topLeading)
        .glassRect(radius: 24)
    }
}



private struct DisplayJobRow: View {
    let title:  String
    let status: String
    let symbol: String
    
    var body: some View {
        HStack(spacing: 10, content: {
            Symbol(symbol)
                .foregroundStyle(.secondary)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2, content: {
                
                Text(title)
                    .font(.callout.weight(.medium))
                Text(status)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            })
            Spacer()
        })
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
}

