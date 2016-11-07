From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 3/3] tpm: move documentation under
 Documentation/security
Date: Mon, 7 Nov 2016 15:37:52 -0700
Message-ID: <20161107153752.3ddb0f52@lwn.net>
References: <20161103235752.19256-1-jarkko.sakkinen@linux.intel.com>
        <20161103235752.19256-4-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20161103235752.19256-4-jarkko.sakkinen@linux.intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu,  3 Nov 2016 17:57:52 -0600
Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:

> In order too make Documentation root directory cleaner move the tpm
> directory under Documentation/security.

So I'll happily apply these to the docs tree, but...

1) It won't apply to current docs-next.  I guess I can manage the merge
   there easily enough, but also,

2) Part 1 of the series (which wasn't sent to me anyway) is not something I
   an apply, so somebody else should pick that one up.

Thanks,

jon
